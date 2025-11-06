# Packages
library(ranger)
library(dplyr)
library(tibble)

# ---------------------------
# 1) DGP (substituído pelo dgp que você forneceu)
# ---------------------------
dgp <- function(n = 1e3, true_tau = 3, stdev = 1, return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  x3 <- rnorm(n)
  x4 <- sample(1:3, n, replace = TRUE)
  x5 <- rbinom(n, 1, 0.5)
  
  g_x4 <- ifelse(x4 == 1, 2, ifelse(x4 == 2, -1, -4))
  mu <- 1 + g_x4 + x1 * x3
  
  s <- sd(mu)
  u <- runif(n, 0, 1)
  pi <- 0.8 * pnorm(3 * mu / s - 0.5 * x1) + 0.05 + u / 10
  pi <- pmin(pmax(pi, 0.01), 0.99)
  
  t  <- rbinom(n, size = 1, prob = pi)
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y  <- ifelse(t == 0, y0, y1)
  
  if (!return_counterfactuals) return(data.frame(x1, x2, x3, x4 = factor(x4), x5, t, y))
  tibble(x1, x2, x3, x4 = factor(x4), x5, t, y0, y1, y)
}

# ---------------------------
# 2) Single run end-to-end (unknown PS estimated via ranger)
# ---------------------------
set.seed(42)

# --- Config ---
n_train  <- 1500
n_test   <- 8000
alpha    <- 0.10          # target 90% coverage for ITE
alpha_out <- alpha / 2      # naive combine: each potential at 1 - alpha/2
q_lo <- 0.10
q_hi <- 0.90
true_tau <- 3              # ajustar conforme desejado
stdev    <- 1

# --- Train + calibration data (with counterfactuals for evaluation convenience) ---
df <- dgp(n_train, true_tau = true_tau, stdev = stdev, return_counterfactuals = TRUE) %>%
  mutate(x_lt = as.integer(x1 < x2))

# 75/25 split
idx_tr <- sample.int(nrow(df), size = floor(0.75 * nrow(df)))
df_tr  <- df[idx_tr, ]
df_ca  <- df[-idx_tr, ]

# ---------- Propensity score estimation (unknown PS) ----------
# Fit classification random forest on TRAIN only (avoid leakage)
# agora usando todas as covariáveis relevantes (x1,x2,x3,x4,x5,x_lt)
rf_ps <- ranger(
  formula = factor(t) ~ x1 + x2 + x3 + x4 + x5,
  data = df_tr,
  probability = TRUE,
  num.trees = 1500,
  min.node.size = 5,
  seed = 2025
)

# Predict P(T=1|X) on CALIBRATION fold
ps_pred <- predict(rf_ps, data = df_ca)$predictions
col_1 <- which(colnames(ps_pred) == "1")
if (length(col_1) == 0) stop("Class '1' not found in propensity prediction columns.")
ehat_ca <- ps_pred[, col_1]
# Numerical stability (avoid exploding weights)
ehat_ca <- pmin(pmax(ehat_ca, 1e-8), 1 - 1e-8)

# ATE weights for calibration
df_ca$w1 <- 1 / ehat_ca
df_ca$w0 <- 1 / (1 - ehat_ca)

# --- Quantile forests per arm (ranger with quantreg) ---
# Arm = 1 (treated)
tr1 <- df_tr %>% filter(t == 1)
rf1 <- ranger(
  formula = y ~ x1 + x2 + x3 + x4 + x5 ,
  data = tr1,
  num.trees = 1500,
  min.node.size = 5,
  quantreg = TRUE,
  seed = 11
)

# Arm = 0 (control)
tr0 <- df_tr %>% filter(t == 0)
rf0 <- ranger(
  formula = y ~ x1 + x2 + x3 + x4 + x5 ,
  data = tr0,
  num.trees = 1500,
  min.node.size = 5,
  quantreg = TRUE,
  seed = 12
)

# --- Conformal calibration (weighted) ---
# Treated calibration quantiles and scores
ca1 <- df_ca %>% filter(t == 1)
q_ca1 <- predict(rf1, data = ca1, type = "quantiles",
                 quantiles = c(q_lo, q_hi))$predictions
ql_ca1 <- q_ca1[, 1]; qh_ca1 <- q_ca1[, 2]
V1 <- pmax(ql_ca1 - ca1$y, ca1$y - qh_ca1)   # two-sided nonconformity
w1 <- ca1$w1

# Weighted (1 - alpha_out)-quantile for V1 (inline, no helper fn)
ok1 <- is.finite(V1) & is.finite(w1) & (w1 >= 0)
V1s <- V1[ok1]; w1s <- w1[ok1]
tau1 <- NA_real_
if (length(V1s) > 0 && sum(w1s) > 0) {
  o1 <- order(V1s); V1so <- V1s[o1]; w1so <- w1s[o1]
  cw1 <- cumsum(w1so) / sum(w1so)
  tau1 <- V1so[which(cw1 >= (1 - alpha_out))[1]]
}

# Control calibration quantiles and scores
ca0 <- df_ca %>% filter(t == 0)
q_ca0 <- predict(rf0, data = ca0, type = "quantiles",
                 quantiles = c(q_lo, q_hi))$predictions
ql_ca0 <- q_ca0[, 1]; qh_ca0 <- q_ca0[, 2]
V0 <- pmax(ql_ca0 - ca0$y, ca0$y - qh_ca0)
w0 <- ca0$w0

ok0 <- is.finite(V0) & is.finite(w0) & (w0 >= 0)
V0s <- V0[ok0]; w0s <- w0[ok0]
tau0 <- NA_real_
if (length(V0s) > 0 && sum(w0s) > 0) {
  o0 <- order(V0s); V0so <- V0s[o0]; w0so <- w0s[o0]
  cw0 <- cumsum(w0so) / sum(w0so)
  tau0 <- V0so[which(cw0 >= (1 - alpha_out))[1]]
}

# --- Test set (with true counterfactuals to evaluate coverage) ---
te <- dgp(n_test, true_tau = true_tau, stdev = stdev, return_counterfactuals = TRUE) %>%
  mutate(x_lt = as.integer(x1 < x2))

# Predict quantiles on test for each arm
qs1 <- predict(rf1, data = te, type = "quantiles",
               quantiles = c(q_lo, q_hi))$predictions
qs0 <- predict(rf0, data = te, type = "quantiles",
               quantiles = c(q_lo, q_hi))$predictions

# Conformal bands per arm (preserve ±Inf if tau is NA)
L1 <- qs1[, 1] - tau1; U1 <- qs1[, 2] + tau1
L0 <- qs0[, 1] - tau0; U0 <- qs0[, 2] + tau0
L1[!is.finite(L1)] <- -Inf; U1[!is.finite(U1)] <-  Inf
L0[!is.finite(L0)] <- -Inf; U0[!is.finite(U0)] <-  Inf

# ITE interval (naive): [L1 - U0, U1 - L0]
L_ITE <- L1 - U0
U_ITE <- U1 - L0

# Coverage on test set
ITE_true <- te$y1 - te$y0
covered  <- as.numeric(ITE_true >= L_ITE & ITE_true <= U_ITE)
coverage <- mean(covered)

# Trivial intervals (-Inf, +Inf): absolute and relative
is_trivial  <- is.infinite(L_ITE) & (L_ITE < 0) & is.infinite(U_ITE) & (U_ITE > 0)
trivial_abs <- sum(is_trivial)
trivial_rel <- trivial_abs / length(L_ITE)

# Average ITE interval length (finite only)
avg_len <- mean((U_ITE - L_ITE)[is.finite(U_ITE - L_ITE)], na.rm = TRUE)

# --- Print results ---
cat(sprintf("Test-set ITE coverage (target %.0f%%): %.3f\n", (1 - alpha) * 100, coverage))
cat(sprintf("Trivial intervals (-Inf,+Inf): %d out of %d (%.3f)\n",
            trivial_abs, length(L_ITE), trivial_rel))
cat(sprintf("Average ITE interval length (finite only): %.3f\n", avg_len))
