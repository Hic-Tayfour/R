# Packages
# install.packages(c("ranger","dplyr","tibble"))
library(ranger)
library(dplyr)
library(tibble)

# ---------------------------
# 1) DGP (as provided)
# ---------------------------
dgp <- function(n = 1e3, true_tau = -1, stdev = 0.7, return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  mu <- ifelse(x1 < x2, 3, -1)
  t  <- rbinom(n, size = 1, prob = pnorm(mu))
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y  <- ifelse(t == 0, y0, y1)
  if (!return_counterfactuals) return(data.frame(x1, x2, t, y))
  tibble(x1, x2, t, y0, y1, y)
}

# -------------------------------------
# 2) Weighted quantile helper (no truncation)
# -------------------------------------
wquantile <- function(x, w, prob) {
  # Returns the weighted prob-quantile; returns NA if invalid weights.
  stopifnot(length(x) == length(w), prob >= 0, prob <= 1)
  ok <- is.finite(x) & is.finite(w) & (w >= 0)
  x <- x[ok]; w <- w[ok]
  if (!length(x)) return(NA_real_)
  o <- order(x); x <- x[o]; w <- w[o]
  sw <- sum(w)
  if (sw <= 0) return(NA_real_)
  cw <- cumsum(w) / sw
  x[which(cw >= prob)[1]]
}

# ------------------------------------------------------
# 3) Train weighted split-CQR on one treatment arm (t=0/1)
#    - Uses 'ranger' with quantile regression
#    - Calibrates conformal scores with ATE weights
# ------------------------------------------------------
train_cqr_arm <- function(df_tr, df_ca, arm = 1,
                          q_lo = 0.10, q_hi = 0.90,
                          alpha_out = 0.025,
                          num.trees = 1500, mtry = NULL,
                          min.node.size = 5, seed = NULL) {
  
  if (!is.null(seed)) set.seed(seed)
  
  # Add a simple indicator that helps represent the mu discontinuity
  tr <- df_tr %>% filter(t == arm) %>% mutate(x_lt = as.integer(x1 < x2))
  ca <- df_ca %>% filter(t == arm) %>% mutate(x_lt = as.integer(x1 < x2))
  
  # Single quantile forest; we'll request both quantiles at predict-time
  rf <- ranger(
    formula = y ~ x1 + x2 + x_lt,
    data = tr,
    num.trees = num.trees,
    mtry = mtry,
    min.node.size = min.node.size,
    quantreg = TRUE,
    seed = seed
  )
  
  # Conformal scores on calibration set (two-sided absolute residuals)
  q_ca <- predict(rf, data = ca, type = "quantiles",
                  quantiles = c(q_lo, q_hi))$predictions
  ql_ca <- q_ca[, 1]
  qh_ca <- q_ca[, 2]
  V <- pmax(ql_ca - ca$y, ca$y - qh_ca)
  
  # ATE weights: w1 = 1/e(x), w0 = 1/(1 - e(x)); PS is known
  w_ca <- if (arm == 1) ca$w1 else ca$w0
  
  # Weighted conformal threshold (no artificial clamping)
  tau <- wquantile(V, w_ca, prob = 1 - alpha_out)
  
  list(rf = rf, q_lo = q_lo, q_hi = q_hi, tau = tau)
}

# ------------------------------------
# 4) Predict conformal interval for one arm
#    - Keeps ±Inf if tau is NA or arithmetic leads to Inf
# ------------------------------------
predict_interval_arm <- function(fit, newdf) {
  newdf <- newdf %>% mutate(x_lt = as.integer(x1 < x2))
  qs <- predict(fit$rf, data = newdf, type = "quantiles",
                quantiles = c(fit$q_lo, fit$q_hi))$predictions
  ql <- qs[, 1]; qh <- qs[, 2]
  
  # Conformal band: [ql - tau, qh + tau]
  L <- ql - fit$tau
  U <- qh + fit$tau
  
  # If tau is NA or results are non-finite, set to ±Inf (no truncation)
  L[!is.finite(L)] <- -Inf
  U[!is.finite(U)] <-  Inf
  cbind(L = L, U = U)
}

# ------------------------------------------------------
# 5) Single run:
#    - Known PS on calibration: e(x) = pnorm(mu(x))
#    - Weighted split-CQR for Y(1) and Y(0)
#    - Combine to ITE interval via naive rule
#    - Report test-set coverage only (no replication)
# ------------------------------------------------------
one_run <- function(n_train = 1500, n_test = 8000,
                    alpha = 0.05, q_lo = 0.10, q_hi = 0.90,
                    true_tau = -1, stdev = 0.7, seed = 123) {
  
  if (!is.null(seed)) set.seed(seed)
  
  # Train+calibration with counterfactuals for internal use only
  df <- dgp(n_train, true_tau = true_tau, stdev = stdev, return_counterfactuals = TRUE) %>%
    mutate(x_lt = as.integer(x1 < x2),
           mu = ifelse(x1 < x2, 3, -1))
  
  # Split 75% train / 25% calibration
  idx_tr <- sample.int(nrow(df), size = floor(0.75 * nrow(df)))
  df_tr  <- df[idx_tr, ]
  df_ca  <- df[-idx_tr, ]
  
  # Known propensity on calibration set
  e_ca <- pnorm(df_ca$mu)
  e_ca <- pmin(pmax(e_ca, 1e-8), 1 - 1e-8) # numeric stability
  
  # ATE weights (weighted method only)
  df_ca$w1 <- 1 / e_ca
  df_ca$w0 <- 1 / (1 - e_ca)
  
  # Each potential outcome uses level 1 - alpha/2 (naive ITE combination)
  alpha_out <- alpha / 2
  
  # Train per arm (weighted split-CQR)
  fit1 <- train_cqr_arm(df_tr, df_ca, arm = 1,
                        q_lo = q_lo, q_hi = q_hi, alpha_out = alpha_out, seed = seed)
  fit0 <- train_cqr_arm(df_tr, df_ca, arm = 0,
                        q_lo = q_lo, q_hi = q_hi, alpha_out = alpha_out, seed = seed)
  
  # Test set with true counterfactuals to evaluate coverage only
  te <- dgp(n_test, true_tau = true_tau, stdev = stdev, return_counterfactuals = TRUE)
  
  # Conformal intervals for Y(1) and Y(0)
  C1 <- predict_interval_arm(fit1, te)
  C0 <- predict_interval_arm(fit0, te)
  
  # Naive ITE interval: [L1 - U0, U1 - L0] — allows ±Inf naturally
  L_ITE <- C1[, "L"] - C0[, "U"]
  U_ITE <- C1[, "U"] - C0[, "L"]
  
  # Test-set coverage: share of times true ITE lies within [L_ITE, U_ITE]
  ITE_true <- te$y1 - te$y0
  covered  <- as.numeric(ITE_true >= L_ITE & ITE_true <= U_ITE)
  mean(covered)
}

# ----------------------------
# 6) Run once and print result
# ----------------------------
set.seed(42)
coverage <- one_run(n_train = 1500, n_test = 8000, alpha = 0.1)
cat(sprintf("Test-set ITE coverage (target 90%%): %.3f\n", coverage))
