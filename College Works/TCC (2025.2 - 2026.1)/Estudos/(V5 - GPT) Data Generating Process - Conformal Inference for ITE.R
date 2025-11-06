# Packages

library(ranger)
library(dplyr)
library(tibble)

# ---------------------------
# 1) DGP (as provided)
# ---------------------------
dgp <- function(n = 1e3,
                true_tau = -1,
                stdev = 0.7,
                return_counterfactuals = FALSE) {
  # true_tau is the CATE = ATE in this homogeneous case
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  mu <- ifelse(x1 < x2, 3, -1)
  t  <- rbinom(n, size = 1, prob = pnorm(mu))
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y  <- ifelse(t == 0, y0, y1)
  if (!return_counterfactuals)
    return(data.frame(x1, x2, t, y))
  tibble(x1, x2, t, y0, y1, y)
}

# ---------------------------
# 2) (Optional) Density-ratio helpers you mentioned
#    NOTE: Not used below (we use ATE weights via known PS).
# ---------------------------
density_ratio <- function(x, mu, Sigma, mu_tilde, Sigma_tilde) {
  exp(
    mvtnorm::dmvnorm(
      x,
      mean = mu_tilde,
      sigma = Sigma_tilde,
      log = TRUE
    ) -
      mvtnorm::dmvnorm(
        x,
        mean = mu,
        sigma = Sigma,
        log = TRUE
      )
  )
}

w <- function(x) {
  density_ratio(x, mu, Sigma, mu_tilde, Sigma_tilde)
}

# ---------------------------
# 3) Single run end-to-end (no extra functions)
# ---------------------------
set.seed(42)

# --- Config ---
n_train  <- 1500
n_test   <- 8000
alpha    <- 0.1           # target 90% coverage

alpha_out <- alpha / 2     # naive ITE: each potential at 1 - alpha/2

q_lo <- 0.10
q_hi <- 0.90

true_tau <- -1
stdev    <- 0.7

# --- Train + calibration data (with counterfactuals only for evaluation convenience) ---

df <- dgp(
  n_train,
  true_tau = true_tau,
  stdev = stdev,
  return_counterfactuals = TRUE
) %>%
  mutate(x_lt = as.integer(x1 < x2), mu = ifelse(x1 < x2, 3, -1))   # needed for known PS

# 75/25 split

idx_tr <- sample.int(nrow(df), size = floor(0.75 * nrow(df)))
df_tr  <- df[idx_tr, ]
df_ca  <- df[-idx_tr, ]

# Known propensity on calibration and ATE weights

e_ca <- pnorm(df_ca$mu)
e_ca <- pmin(pmax(e_ca, 1e-8), 1 - 1e-8)   # numeric stability
df_ca$w1 <- 1 / e_ca
df_ca$w0 <- 1 / (1 - e_ca)

# --- Fit quantile forests for each arm (ranger with quantreg) ---
# Arm = 1

tr1 <- df_tr %>% filter(t == 1)
rf1 <- ranger(
  formula = y ~ x1 + x2 + x_lt,
  data = tr1,
  num.trees = 1500,
  min.node.size = 5,
  quantreg = TRUE,
  seed = 42
)
# Calibration predictions on treated

ca1 <- df_ca %>% filter(t == 1)
q_ca1 <- predict(rf1,
                 data = ca1,
                 type = "quantiles",
                 quantiles = c(q_lo, q_hi))$predictions
ql_ca1 <- q_ca1[, 1]
qh_ca1 <- q_ca1[, 2]
V1 <- pmax(ql_ca1 - ca1$y, ca1$y - qh_ca1)  # two-sided residuals
w1 <- ca1$w1

# Weighted (1 - alpha_out)-quantile for treated score V1 (inline, no helper fn)

ok1   <- is.finite(V1) & is.finite(w1) & (w1 >= 0)
V1s   <- V1[ok1]
w1s   <- w1[ok1]
tau1  <- NA_real_

if (length(V1s) > 0 && sum(w1s) > 0) {
  o1    <- order(V1s)
  V1so  <- V1s[o1]
  w1so <- w1s[o1]
  cw1   <- cumsum(w1so) / sum(w1so)
  k1    <- which(cw1 >= (1 - alpha_out))[1]
  tau1  <- V1so[k1]
}

# Arm = 0

tr0 <- df_tr %>% filter(t == 0)
rf0 <- ranger(
  formula = y ~ x1 + x2 + x_lt,
  data = tr0,
  num.trees = 1500,
  min.node.size = 5,
  quantreg = TRUE,
  seed = 43
)
# Calibration predictions on controls

ca0 <- df_ca %>% filter(t == 0)
q_ca0 <- predict(rf0,
                 data = ca0,
                 type = "quantiles",
                 quantiles = c(q_lo, q_hi))$predictions
ql_ca0 <- q_ca0[, 1]
qh_ca0 <- q_ca0[, 2]
V0 <- pmax(ql_ca0 - ca0$y, ca0$y - qh_ca0)
w0 <- ca0$w0

# Weighted (1 - alpha_out)-quantile for control score V0 (inline)

ok0   <- is.finite(V0) & is.finite(w0) & (w0 >= 0)
V0s   <- V0[ok0]
w0s   <- w0[ok0]
tau0  <- NA_real_
if (length(V0s) > 0 && sum(w0s) > 0) {
  o0    <- order(V0s)
  V0so  <- V0s[o0]
  w0so <- w0s[o0]
  cw0   <- cumsum(w0so) / sum(w0so)
  k0    <- which(cw0 >= (1 - alpha_out))[1]
  tau0  <- V0so[k0]
}

# --- Test set with true counterfactuals for evaluation ---

te <- dgp(
  n_test,
  true_tau = true_tau,
  stdev = stdev,
  return_counterfactuals = TRUE
) %>%
  mutate(x_lt = as.integer(x1 < x2))

# Predict quantiles on test for each arm

qs1 <- predict(rf1,
               data = te,
               type = "quantiles",
               quantiles = c(q_lo, q_hi))$predictions

qs0 <- predict(rf0,
               data = te,
               type = "quantiles",
               quantiles = c(q_lo, q_hi))$predictions

# Conformal bands per arm (allow ±Inf if tau is NA/non-finite)

L1 <- qs1[, 1] - tau1
U1 <- qs1[, 2] + tau1
L0 <- qs0[, 1] - tau0
U0 <- qs0[, 2] + tau0

L1[!is.finite(L1)] <- -Inf
U1[!is.finite(U1)] <-  Inf
L0[!is.finite(L0)] <- -Inf
U0[!is.finite(U0)] <-  Inf

# Naive ITE interval: [L1 - U0, U1 - L0]

L_ITE <- L1 - U0
U_ITE <- U1 - L0

# Test coverage (true ITE from counterfactuals)

ITE_true <- te$y1 - te$y0
covered  <- as.numeric(ITE_true >= L_ITE & ITE_true <= U_ITE)
coverage <- mean(covered)

# Trivial intervals count: (-Inf, +Inf)

is_trivial <- is.infinite(L_ITE) &
  (L_ITE < 0) & is.infinite(U_ITE) & (U_ITE > 0)
trivial_abs <- sum(is_trivial)
trivial_rel <- trivial_abs / length(L_ITE)

# --- Print results ---

cat(sprintf(
  "Test-set ITE coverage (target %.0f%%): %.3f\n",
  (1 - alpha) * 100,
  coverage
))

cat(
  sprintf(
    "Trivial intervals (-Inf,+Inf): %d out of %d (%.3f)\n",
    trivial_abs,
    length(L_ITE),
    trivial_rel
  )
)

mean((U_ITE - L_ITE)[is.finite(U_ITE - L_ITE)], na.rm = TRUE)
