# Bibliotecas necessárias para todos os DGPs
library(tibble)
library(MASS)
library(tidyverse)

# 1º Data Generating Process (DGP) - Hahn, Murray & Carvalho ----      

dgp_hmc <- function(n = 1e3,
                           cate = -1, 
                           stdev = 0.7,
                           return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  mu <- ifelse(x1 < x2, 3, -1)
  ps <- pnorm(mu)
  t  <- rbinom(n, size = 1, prob = ps)
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + cate + rnorm(n, sd = stdev)
  y <- ifelse(t == 0, y0, y1)
  if (!return_counterfactuals) {
    return(data.frame(x1, x2, t, y))
  }
  tibble(
    x1 = x1,
    x2 = x2,
    t = t,
    y = y,
    y0 = y0,
    y1 = y1,
    ite_true = y1 - y0,
    ps = ps
  )
}

# ====

# 2º Data Generating Process (DGP) - Hahn, Murray & Carvalho; Simulação Seção 6.1 ----

dgp_hmc_complex <- function(n = 1e3,
                            true_tau = 3,
                            stdev = 1,
                            return_counterfactuals = FALSE) {
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  x3 <- rnorm(n)
  x4 <- sample(1:3, n, replace = TRUE)
  x5 <- rbinom(n, 1, 0.5)
  
  g_x4 <- ifelse(x4 == 1, 2, ifelse(x4 == 2, -1, -4))
  mu <- 1 + g_x4 + x1 * x3
  
  s <- sd(mu)
  u <- runif(n, 0, 1)
  ps <- 0.8 * pnorm(3 * mu / s - 0.5 * x1) + 0.05 + u / 10
  ps <- pmin(pmax(ps, 0.01), 0.99)
  
  t  <- rbinom(n, size = 1, prob = ps)
  y0 <- mu + rnorm(n, sd = stdev)
  y1 <- mu + true_tau + rnorm(n, sd = stdev)
  y  <- ifelse(t == 0, y0, y1)
  
  if (!return_counterfactuals) {
    return(data.frame(x1, x2, x3, x4 = factor(x4), x5, t, y, ps))
  }
  
  tibble(
    x1 = x1,
    x2 = x2,
    x3 = x3,
    x4 = factor(x4),
    x5 = x5,
    t = t,
    y = y,
    y0 = y0,
    y1 = y1,
    ite_true = y1 - y0, 
    ps = ps            
  )
}
# ====


# 3º Data Generating Process (DGP) - Lei & Candès; DGP Causal Complexo ----

dgp_lei_complex <- function(n,
                            d = 10, 
                            rho = 0.9,
                            heteroscedastic = FALSE,
                            return_counterfactuals = TRUE) {
  
  mu_corr <- rep(0, d)
  Sigma <- matrix(rho, nrow = d, ncol = d)
  diag(Sigma) <- 1
  X_mat <- MASS::mvrnorm(n = n, mu = mu_corr, Sigma = Sigma)
  X_mat <- pnorm(X_mat) 
  X_df <- as.data.frame(X_mat)
  colnames(X_df) <- paste0("x", 1:d)
  list2env(X_df, envir = environment()) 
  mu0_func <- 2 * x1 - 3 * x2 + 5 * x1 * x2
  y0 <- mu0_func + rnorm(n, mean = 0, sd = 0.5)
  f_cate <- function(x) {
    2 / (1 + exp(-12 * (x - 0.5)))
  }
  cate_func <- f_cate(x1) * f_cate(x2)
  epsilon <- rnorm(n, mean = 0, sd = 1)
  if (heteroscedastic) {
    sigma_X <- -log(x1 + 1e-9)
  } else {
    sigma_X <- 1
  }
  y1 <- y0 + cate_func + sigma_X * epsilon
  pi <- 0.25 * (1 + pbeta(x1, shape1 = 2, shape2 = 4)) 
  t  <- rbinom(n = n, size = 1, prob = pi)
  y  <- t * y1 + (1 - t) * y0
  
  if (!return_counterfactuals) {
    df_simple <- as.data.frame(X_mat)
    colnames(df_simple) <- paste0("x", 1:d)
    df_simple$t <- t
    df_simple$y <- y
    df_simple$ps <- pi 
    return(df_simple)
  }
  
  tibble(
    x1 = x1,
    x2 = x2,
    x3 = x3,
    x4 = x4,
    x5 = x5,
    x6 = x6,
    x7 = x7,
    x8 = x8,
    x9 = x9,
    x10 = x10,
    t = t,
    y0 = y0,
    y1 = y1,
    y = y,
    ite_true = y1 - y0, 
    ps = pi           
  )
}

# ====

# 4º Data Generating Process (DGP) - Lei & Candès; Simulação Seção 3.6 ----

dgp_lei_sec36 <- function(n,
                          d = 10,
                          rho = 0,
                          hetero = FALSE,
                          return_counterfactuals = FALSE) {
  
  Sigma <- matrix(rho, nrow = d, ncol = d)
  diag(Sigma) <- 1
  Z <- MASS::mvrnorm(n, mu = rep(0, d), Sigma = Sigma)
  X_mat <- pnorm(Z) 
  X_df <- as.data.frame(X_mat)
  colnames(X_df) <- paste0("x", 1:d)
  list2env(X_df, envir = environment()) 
  f_cate <- function(x) 2 / (1 + exp(-12 * (x - 0.5)))
  cate_func <- f_cate(x1) * f_cate(x2)
  sigma <- if (hetero) {
    sqrt(pmax(-log(pmax(x1, 1e-12)), 0))
  } else {
    1
  }
  y0 <- rep(0, n)
  y1 <- cate_func + sigma * rnorm(n)
  pi <- 0.25 * (1 + pbeta(x1, 2, 4)) 
  t  <- rbinom(n, size = 1, prob = pi)
  y  <- ifelse(t == 1, y1, y0)
  
  if (!return_counterfactuals) {
    df_simple <- as.data.frame(X_mat)
    colnames(df_simple) <- paste0("x", 1:d)
    df_simple$t <- t
    df_simple$y <- y
    df_simple$ps <- pi 
    return(df_simple)
  }
  
  tibble(
    x1 = x1,
    x2 = x2,
    x3 = x3,
    x4 = x4,
    x5 = x5,
    x6 = x6,
    x7 = x7,
    x8 = x8,
    x9 = x9,
    x10 = x10,
    t = t,
    y0 = y0,
    y1 = y1,
    y = y,
    ite_true = y1 - y0, 
    ps = pi           
  )
}

# ====

# 5º # DGP 5: Hahn, Murray & Carvalho; Blog Post "ML for Causal Inference"

dgp_hahn <- function(n = 1000,
                     v = 30,    
                     kappa = 2, 
                     return_counterfactuals = FALSE) {
  
  x <- seq(0, 1, length.out = n)
  mu_x <- 2 * (sin(v * x) + 1)
  tau_x <- -1 + x
  ps <- mu_x / 5 + 0.1 
  ps <- pmin(pmax(ps, 0.001), 0.999) 
  
  t  <- rbinom(n, 1, prob = ps)
  f_xz_esperado <- mu_x + tau_x * t
  sigma <- kappa * sd(f_xz_esperado)
  noise <- sigma * rnorm(n)
  
  y0 <- mu_x + noise
  y1 <- mu_x + tau_x + noise
  y  <- ifelse(t == 0, y0, y1)
  
  if (!return_counterfactuals) {
    return(data.frame(x = x, t = t, y = y, ps = ps))
  }
  
  tibble(
    x = x,
    t = t,
    y = y,
    y0 = y0,
    y1 = y1,
    ite_true = y1 - y0,
    ps = ps            
  )
}

# ====

df_hmc <- dgp_hmc(n = 500, return_counterfactuals = TRUE)

df_hmc_ml <- df_hmc %>%
  select(-y0, -y1, -ite_true, -ps)

df_hmc_complex <- dgp_hmc_complex(n = 500, return_counterfactuals = TRUE)

df_hmc_complex_ml <- df_hmc_complex %>%
  select(-y0, -y1, -ite_true, -ps)

df_hahn <- dgp_hahn(n = 500, return_counterfactuals = TRUE)

df_hahn_ml <- df_hahn %>%
  select(-y0, -y1, -ite_true, -ps)

df_lei_complex <- dgp_lei_complex(n = 500,
                                  d = 10,
                                  return_counterfactuals = TRUE)

df_lei_complex_ml <- df_lei_complex %>%
  select(-y0, -y1, -ite_true, -ps)

df_lei_sec36 <- dgp_lei_sec36(n = 500,
                              d = 10,
                              return_counterfactuals = TRUE)

df_lei_sec36_ml <- df_lei_sec36 %>%
  select(-y0, -y1, -ite_true, -ps)

df
