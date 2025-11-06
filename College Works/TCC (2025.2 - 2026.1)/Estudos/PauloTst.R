library(tidyverse)
library(ranger)

friedman <- function(n, p = 10) {
  X <- matrix(runif(n*p), nrow = n, ncol = p, dimnames = list(1:n, paste0("x_", 1:p)))
  y <- 10*sin(pi*X[, 1]*X[, 2]) + 20*(X[, 3] - 0.5)^2 + 10*X[, 4] + 5*X[, 5] + rnorm(n)
  data.frame(cbind(y, X))
}

set.seed(42)

# Classical

alpha <- 0.1

n_trn <- 1e4
n <- 2e3
n_tst <- 2e3

set.seed(42)

trn <- friedman(n_trn)
cal <- friedman(n)
tst <- friedman(n_tst)

rf <- ranger(y ~., data = trn)

mu_hat_cal <- predict(rf, data = cal)$prediction

R <- abs(cal$y - mu_hat_cal)
r_hat <- sort(R)[ceiling((1-alpha)*(n+1))]

mu_hat_tst <- predict(rf, data = tst)$prediction

lower <- mu_hat_tst - r_hat
upper <- mu_hat_tst + r_hat 

mean((lower <= tst$y) & (tst$y <= upper))


# Standart

y_hat_trn <- predict(rf, data = trn)$prediction

trn_res <- trn %>% 
  mutate(delta = abs(y - y_hat_trn)) %>% 
  select(-y)

rf_res <- ranger(delta ~. , data = trn_res)

sig_hat_cal <- predict(rf_res, data = cal)$prediction

R <- abs(cal$y - mu_hat_cal)/sig_hat_cal

r_hat <- sort(R)[ceiling((1-alpha)*(n+1))]

sig_hat_tst <- predict(rf_res, data = tst)$prediction

lower <- mu_hat_tst - r_hat *  sig_hat_tst
upper <- mu_hat_tst + r_hat * sig_hat_tst

mean((lower <= tst$y) & (tst$y <= upper))

summary(upper - lower)


## CQR 

rf <- ranger(y ~ ., data = trn, quantreg = TRUE)

alpha_low <- alpha / 2
alpha_high <- 1 - alpha /2

q_hat_cal <- predict(
  rf,
  data = cal,
  type = "quantiles",
  quantiles = c(alpha_low, alpha_high)
)$predictions

R <- pmax(q_hat_cal[, 1] - cal$y, cal$y - q_hat_cal[, 2])

r_hat <- sort(R)[(1 - alpha)*(nrow(cal) + 1)]

q_hat_tst <- predict(
  rf,
  data = tst,
  type = "quantiles",
  quantiles = c(alpha_low, alpha_high)
)$predictions

lower <- q_hat_tst[, 1] - r_hat
upper <- q_hat_tst[, 2] + r_hat

summary(upper - lower)

