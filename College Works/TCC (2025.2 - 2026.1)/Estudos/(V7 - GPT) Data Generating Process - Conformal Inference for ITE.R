# Packages
# install.packages(c("ranger","MASS","dplyr","tibble"))
library(ranger)
library(MASS)
library(dplyr)
library(tibble)

# ------------------------------------------------------------
# 1) DGP of Section 3.6 (KNOWN propensity score)  — the ONLY function
# ------------------------------------------------------------
dgp36 <- function(n = 2000,
                  d = 10,
                  rho = 0,
                  hetero = FALSE,
                  return_counterfactuals = FALSE,
                  seed = NULL) {
  if (!is.null(seed))
    set.seed(seed)
  
  # Equicorrelated Gaussian Z, Uniform marginals via Phi
  Sigma <- matrix(rho, nrow = d, ncol = d)
  diag(Sigma) <- 1
  Z <- MASS::mvrnorm(n, mu = rep(0, d), Sigma = Sigma)
  X <- pnorm(Z)
  colnames(X) <- paste0("x", seq_len(d))
  
  # Mean and noise for Y(1)
  f   <- function(x)
    2 / (1 + exp(-12 * (x - 0.5)))
  mu1 <- f(X[, 1]) * f(X[, 2])
  sigma <- if (hetero)
    sqrt(pmax(-log(pmax(X[, 1], 1e-12)), 0))
  else
    1
  
  # Potential outcomes and observed DGP
  y0 <- rep(0, n)
  y1 <- mu1 + sigma * rnorm(n)
  
  # Known PS e(x) in [0.25, 0.5]
  e  <- 0.25 * (1 + pbeta(X[, 1], shape1 = 2, shape2 = 4))
  
  t  <- rbinom(n, size = 1, prob = e)
  y  <- ifelse(t == 1, y1, y0)
  
  df <- as_tibble(X) %>% mutate(t = t, y = y, e = e)
  if (!return_counterfactuals)
    return(df)
  df %>% mutate(y0 = y0, y1 = y1)
}

# ------------------------------------------------------------
# 2) Single run — weighted split-CQR on treated, PS known (ATE)
#    No extra helper functions; everything inline.
# ------------------------------------------------------------
set.seed(42)

# Config
n_train <- 2000
n_test  <- 8000
d <- 10
rho <- 0
hetero <- FALSE
alpha <- 0.10                 # target 95% coverage for ITE (== Y(1))
q_lo <- 0.10
q_hi <- 0.90

# Train+calibration (counterfactuals available only for evaluation)
df_full <- dgp36(
  n_train,
  d = d,
  rho = rho,
  hetero = hetero,
  return_counterfactuals = TRUE,
  seed = 123
)

# 75/25 split
idx_tr <- sample.int(nrow(df_full), size = floor(0.75 * nrow(df_full)))
df_tr  <- df_full[idx_tr, ]
df_ca  <- df_full[-idx_tr, ]

# Fit quantile forest on treated arm (Y | X, T=1)
xcols <- grep("^x[0-9]+$", names(df_tr), value = TRUE)
form  <- as.formula(paste("y ~", paste(xcols, collapse = " + ")))
rf1 <- ranger(
  formula       = form,
  data          = df_tr[df_tr$t == 1, ],
  num.trees     = 1500,
  min.node.size = 5,
  quantreg      = TRUE,
  seed          = 2025
)

# Weighted conformal calibration on treated subset
ca1   <- df_ca[df_ca$t == 1, ]
q_ca  <- predict(rf1,
                 data = ca1[, xcols, drop = FALSE],
                 type = "quantiles",
                 quantiles = c(q_lo, q_hi))$predictions
ql_ca <- q_ca[, 1]
qh_ca <- q_ca[, 2]
V     <- pmax(ql_ca - ca1$y, ca1$y - qh_ca)  # two-sided nonconformity
e_ca  <- pmin(pmax(ca1$e, 1e-12), 1 - 1e-12)
w1    <- 1 / e_ca                             # ATE weights

# Weighted (1 - alpha)-quantile for V (inline; no helper function)
ok <- is.finite(V) & is.finite(w1) & (w1 >= 0)
Vok <- V[ok]
wok <- w1[ok]
tau <- NA_real_
if (length(Vok) > 0 && sum(wok) > 0) {
  o  <- order(Vok)
  Vso <- Vok[o]
  wso <- wok[o]
  cw <- cumsum(wso) / sum(wso)
  tau <- Vso[which(cw >= (1 - alpha))[1]]
}

# Test set (with true counterfactuals to evaluate coverage)
te <- dgp36(
  n_test,
  d = d,
  rho = rho,
  hetero = hetero,
  return_counterfactuals = TRUE,
  seed = 124
)

# Predict quantiles for Y(1) on test; conformal band = [q_lo - tau, q_hi + tau]
qs <- predict(rf1,
              data = te[, xcols, drop = FALSE],
              type = "quantiles",
              quantiles = c(q_lo, q_hi))$predictions
L  <- qs[, 1] - tau
U  <- qs[, 2] + tau
L[!is.finite(L)] <- -Inf
U[!is.finite(U)] <-  Inf  # keep ±Inf if needed

# ITE = Y(1) - 0  → coverage on test
ITE_true <- te$y1
covered  <- as.numeric(ITE_true >= L & ITE_true <= U)
coverage <- mean(covered)

# Trivial intervals (-Inf, +Inf): absolute and relative
is_trivial  <- is.infinite(L) & (L < 0) & is.infinite(U) & (U > 0)
trivial_abs <- sum(is_trivial)
trivial_rel <- trivial_abs / length(L)

# Average interval length (finite only)
avg_len <- mean((U - L)[is.finite(U - L)], na.rm = TRUE)

# Print results
cat(sprintf("Test-set ITE coverage (target 90%%): %.3f\n", coverage))
cat(
  sprintf(
    "Trivial intervals (-Inf,+Inf): %d out of %d (%.3f)\n",
    trivial_abs,
    length(L),
    trivial_rel
  )
)
cat(sprintf("Average ITE interval length (finite only): %.3f\n", avg_len))
