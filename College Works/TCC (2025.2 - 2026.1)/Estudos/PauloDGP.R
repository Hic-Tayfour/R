# Seminário com este DGP: https://www.youtube.com/watch?v=xm1CJCCNirY

# rm(list = ls())

library(tidyverse)
library(ranger)

dgp <- function(n = 1e3, true_tau = -1, stdev = 0.7, return_counterfactuals = FALSE) {
    # true_tau is the CATE = ATE in this homogeneous case
    x1 <- rnorm(n)
    x2 <- rnorm(n)
    # originally (1, -1)
    mu <- ifelse(x1 < x2, 3, -1)
    t <- rbinom(n, size = 1, prob = pnorm(mu))
    y0 <- mu + rnorm(n, sd = stdev)
    y1 <- mu + true_tau + rnorm(n, sd = stdev)
    y <- ifelse(t == 0, y0, y1)
    if (!return_counterfactuals) return(data.frame(x1, x2, t, y))
    tibble(x1, x2, t, y0, y1, y)
}

###

db <- dgp(1e3, return_counterfactuals = TRUE)

mean(db$y1 - db$y0) # ATE (tau) estimate

###

db <- dgp(1e3)

rf <- ranger(factor(t) ~ x1 + x2, data = db, probability = TRUE)

pi_hat <- predict(rf, data = db)$predictions[, 2]

x1 <- rnorm(1e3)
x2 <- rnorm(1e3)
mu <- ifelse(x1 < x2, 3, -1)
pnorm <- pnorm(mu)
t <- rbinom(1e3, size = 1, prob = pnorm(mu))
y0 <- mu + rnorm(1e3, sd = 0.7)
y1 <- mu + -1 + rnorm(1e3, sd = 0.7)
y <- ifelse(t == 0, y0, y1)


df <- data.frame(
  x1 = x1,
  x2 = x2,
  mu = mu,
  pnorm = pnorm,
  t = t,
  y0 = y0, 
  y1 = y1,
  y = y
)
