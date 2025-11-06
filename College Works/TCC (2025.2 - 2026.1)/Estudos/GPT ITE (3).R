# Packages
# install.packages(c("ranger","MASS","dplyr","tibble"))
library(ranger)
library(MASS)
library(dplyr)
library(tibble)

# ------------------------------------------------------------
# 1) DGP of Section 3.6 (KNOWN propensity score)
#    - X_j = Phi(Z_j), with Z ~ MVN(0, Sigma_rho) (equicorrelated)
#    - Y(0) = 0
#    - E[Y(1) | X] = f(X1)*f(X2), where f(x) = 2 / (1 + exp(-12*(x - 0.5)))
#    - Homoskedastic:  sigma^2(x) = 1
#      (set hetero=TRUE to use heteroskedastic: sigma^2(x) = -log(X1))
#    - Known PS: e(x) = 0.25 * (1 + BetaCDF_{a=2,b=4}(X1)) ∈ [0.25, 0.5]
# ------------------------------------------------------------
dgp36 <- function(n = 2000, d = 10, rho = 0, hetero = FALSE,
                  return_counterfactuals = FALSE, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  
  # Build equicorrelation covariance matrix for Z
  Sigma <- matrix(rho, nrow = d, ncol = d)
  diag(Sigma) <- 1
  
  # Generate Z and transform marginals to Uniform(0,1) via Phi
  Z <- MASS::mvrnorm(n, mu = rep(0, d), Sigma = Sigma)
  X <- pnorm(Z)
  colnames(X) <- paste0("x", seq_len(d))
  
  # Mean function for Y(1)
  f   <- function(x) 2 / (1 + exp(-12 * (x - 0.5)))
  mu1 <- f(X[, 1]) * f(X[, 2])
  
  # Noise scale
  sigma <- if (hetero) sqrt(pmax(-log(pmax(X[, 1], 1e-12)), 0)) else 1
  
  # Potential outcomes and observed assignment/outcome
  y0 <- rep(0, n)
  y1 <- mu1 + sigma * rnorm(n)
  
  # Known propensity score from the DGP
  e  <- 0.25 * (1 + pbeta(X[, 1], shape1 = 2, shape2 = 4))
  
  t  <- rbinom(n, size = 1, prob = e)
  y  <- ifelse(t == 1, y1, y0)
  
  df <- as_tibble(X) %>% mutate(t = t, y = y, e = e)
  if (!return_counterfactuals) return(df)
  df %>% mutate(y0 = y0, y1 = y1)
}

# ------------------------------------------------------------
# 2) Weighted quantile helper (no artificial truncation)
#    - Returns NA if weights are invalid; caller may map NA -> ±Inf later
# ------------------------------------------------------------
wquantile <- function(x, w, prob) {
  stopifnot(length(x) == length(w), prob >= 0, prob <= 1)
  ok <- is.finite(x) & is.finite(w) & (w >= 0)
  x <- x[ok]; w <- w[ok]
  if (!length(x)) return(NA_real_)
  o  <- order(x); x <- x[o]; w <- w[o]
  sw <- sum(w)
  if (sw <= 0) return(NA_real_)
  cw <- cumsum(w) / sw
  x[which(cw >= prob)[1]]
}

# ------------------------------------------------------------
# 3) Train weighted split-CQR on the treated arm (t == 1)
#    - 'ranger' quantile forest for conditional quantiles of Y | X, T=1
#    - Conformal scores V = max(q_lo - y, y - q_hi) on calibration treated set
#    - ATE weights with KNOWN PS: w1(x) = 1 / e(x)
#    - Target coverage: 1 - alpha  (since ITE = Y(1) - 0)
# ------------------------------------------------------------
train_cqr_treated <- function(df_tr, df_ca,
                              alpha = 0.05,
                              q_lo = 0.10, q_hi = 0.90,
                              num.trees = 1500, mtry = NULL,
                              min.node.size = 5, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  
  tr <- df_tr %>% filter(t == 1)
  ca <- df_ca %>% filter(t == 1)
  
  # Features used in the model
  xcols <- grep("^x[0-9]+$", names(tr), value = TRUE)
  form  <- as.formula(paste("y ~", paste(xcols, collapse = " + ")))
  
  # One quantile forest; we will request both quantiles at prediction time
  rf <- ranger(
    formula       = form,
    data          = tr,
    num.trees     = num.trees,
    mtry          = mtry,
    min.node.size = min.node.size,
    quantreg      = TRUE,
    seed          = seed
  )
  
  # Predict lower/upper quantiles on calibration set (treated only)
  q_ca  <- predict(rf, data = ca[, xcols, drop = FALSE],
                   type = "quantiles",
                   quantiles = c(q_lo, q_hi))$predictions
  ql_ca <- q_ca[, 1]
  qh_ca <- q_ca[, 2]
  
  # Two-sided nonconformity scores
  V <- pmax(ql_ca - ca$y, ca$y - qh_ca)
  
  # ATE weights (KNOWN PS): w1 = 1 / e(x)
  e_ca <- pmin(pmax(ca$e, 1e-12), 1 - 1e-12)  # numeric safety
  w_ca <- 1 / e_ca
  
  # Weighted conformal threshold for 1 - alpha coverage
  tau <- wquantile(V, w_ca, prob = 1 - alpha)
  
  list(rf = rf, xcols = xcols, q_lo = q_lo, q_hi = q_hi, tau = tau)
}

# ------------------------------------------------------------
# 4) Predict conformal interval for Y(1)
#    - Interval: [ q_lo(X) - tau , q_hi(X) + tau ]
#    - Keeps ±Inf if tau is NA or arithmetic yields non-finite results
# ------------------------------------------------------------
predict_interval_y1 <- function(fit, newdf) {
  qs <- predict(fit$rf, data = newdf[, fit$xcols, drop = FALSE],
                type = "quantiles",
                quantiles = c(fit$q_lo, fit$q_hi))$predictions
  ql <- qs[, 1]
  qh <- qs[, 2]
  
  L <- ql - fit$tau
  U <- qh + fit$tau
  
  # Preserve ±Inf for any non-finite results
  L[!is.finite(L)] <- -Inf
  U[!is.finite(U)] <-  Inf
  
  cbind(L = L, U = U)
}

# ------------------------------------------------------------
# 5) Single run end-to-end:
#    - Generate train/calibration with counterfactuals (for eval only)
#    - Fit weighted split-CQR on treated using KNOWN PS ATE weights
#    - Generate test set; compute coverage and trivial-interval counts
#      * ITE = Y(1) - 0, so ITE interval ≡ Y(1) interval
# ------------------------------------------------------------
one_run <- function(n_train = 2000, n_test = 8000,
                    d = 10, rho = 0, hetero = FALSE,
                    alpha = 0.05, seed = 123) {
  if (!is.null(seed)) set.seed(seed)
  
  # Train + calibration data (with counterfactuals available)
  df_full <- dgp36(n_train, d = d, rho = rho, hetero = hetero,
                   return_counterfactuals = TRUE, seed = seed)
  
  # 75/25 split
  idx_tr <- sample.int(nrow(df_full), size = floor(0.75 * nrow(df_full)))
  df_tr  <- df_full[idx_tr, ]
  df_ca  <- df_full[-idx_tr, ]
  
  # Fit weighted split-CQR on treated (ATE weights with KNOWN PS)
  fit1 <- train_cqr_treated(df_tr, df_ca, alpha = alpha, seed = seed)
  
  # Test set (with true counterfactuals to evaluate coverage)
  te <- dgp36(n_test, d = d, rho = rho, hetero = hetero,
              return_counterfactuals = TRUE, seed = seed + 1)
  
  # Conformal interval for Y(1) on test; ITE interval is identical (Y(0)=0)
  C1 <- predict_interval_y1(fit1, te)
  L  <- C1[, "L"]; U <- C1[, "U"]
  
  # Trivial intervals: (-Inf, +Inf)
  is_trivial <- is.infinite(L) & (L < 0) & is.infinite(U) & (U > 0)
  trivial_abs <- sum(is_trivial)
  trivial_rel <- trivial_abs / length(L)
  
  # Test-set coverage for ITE = Y(1)
  ITE_true <- te$y1
  covered  <- as.numeric(ITE_true >= L & ITE_true <= U)
  coverage <- mean(covered)
  
  list(
    coverage     = coverage,
    trivial_abs  = trivial_abs,
    trivial_rel  = trivial_rel,
    n_test       = length(L)
  )
}

# ------------------------------------------------------------
# 6) Run once and print results (choose scenario as desired)
#    Example scenario: d=10, rho=0, homoskedastic, alpha=0.05
# ------------------------------------------------------------
set.seed(42)
res <- one_run(n_train = 2000, n_test = 8000,
               d = 10, rho = 0, hetero = FALSE, alpha = 0.20)

cat(sprintf("Test-set ITE coverage (target 95%%): %.3f\n", res$coverage))
cat(sprintf("Trivial intervals (-Inf,+Inf): %d out of %d (%.3f)\n",
            res$trivial_abs, res$n_test, res$trivial_rel))
