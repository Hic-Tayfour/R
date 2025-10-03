# 📘 Estudos do TCC — Predição Conformal (TCC | 2025.2–2026.1)

Este repositório reúne três estudos em **R** sobre **Predição Conformal** aplicados a diferentes cenários:

1. **Conformal Prediction clássico, padronizado e QRF** em DGP Friedman (script: *Estudo Conformal Prediction.R*)
2. **Covariate Shift (DGP Gaussiana Bivariada)** com pesos paramétricos (script: *Estudo Covariate Shift.R*)
3. **Covariate Shift (Friedman-1)** com pesos via classificação (script: *Estudo Covariate Shift (FriedmanDataGeneration).R*)

Todos os scripts utilizam **Random Forest** (`ranger`) como estimador principal e seguem a estrutura de **Split Conformal Prediction**.

---

## 📄 Estudo Conformal Prediction.R

### 🎯 Objetivo

Comparar três variantes de predição conformal em dados simulados Friedman-1:

* **Split clássico** (resíduo absoluto)
* **Split padronizado** (heteroscedastic-aware)
* **Quantile Random Forest**

### 📊 Dados

* DGP Friedman-1 com $p=10$.
* Treino = 20.000, calibração = 3.000, teste = 3.000.
* Resposta:

  $$y = 10\sin(\pi x_1x_2) + 20(x_3-0.5)^2 + 10x_4 + 5x_5 + \varepsilon$$

### 🧪 Etapas

1. **Split clássico:** intervalos simétricos por score absoluto.
2. **Split padronizado:** divisão do resíduo pela escala estimada ($\hat\sigma(x)$).
3. **Quantile Random Forest:** intervalos pelos quantis preditos, ajustados com conformal.

### 📈 Saídas

* Cobertura empírica
* Largura média
* Gráficos de intervalos nas 50 primeiras observações

---

## 📄 Estudo Covariate Shift.R — DGP Gaussiana Bivariada

### 🎯 Objetivo

Avaliar intervalos conformais sob **mudança de distribuição** entre treino e teste, usando pesos da **razão de densidade paramétrica**.

### 📊 Dados

* Treino/Calibração: $X \sim \mathcal{N}((2,0),\Sigma)$, $\Sigma=\begin{pmatrix}1&0.8\\0.8&1\end{pmatrix}$.
* Teste: $X \sim \mathcal{N}((1,0),\Sigma_t)$, $\Sigma_t=\begin{pmatrix}1&0.7\\0.7&1\end{pmatrix}$.
* Resposta:

  $$y = 2x_1 + \sin(\pi x_1x_2) - x_2^2$$

### 🧪 Etapas

1. Geração de treino (20.000), calibração (3.000) e teste (3.000).
2. Ajuste de Random Forest para $\hat\mu(x)$.
3. Cálculo de pesos $w(x)=p_{\text{teste}}(x)/p_{\text{treino}}(x)$.
4. Construção de intervalos conformais ponderados.

### 📈 Saídas

* Métricas de cobertura e largura média
* Gráfico de densidades conjuntas (treino vs. teste)
* Intervalos conformais nas 50 primeiras observações

---

## 📄 Estudo Covariate Shift (FriedmanDataGeneration).R

### 🎯 Objetivo

Explorar intervalos conformais sob covariate shift em alta dimensão, com pesos estimados por **classificação probabilística**.

### 📊 Dados

* Treino/Calibração: $x_j \sim U(0,1)$.
* Teste: $x_1,x_2 \sim U(0.2,1)$, demais $U(0,1)$.
* Resposta: Friedman-1

  $$y = 10\sin(\pi x_1x_2)+20(x_3-0.5)^2+10x_4+5x_5+\varepsilon$$

### 🧪 Etapas

1. Geração de treino (20.000), calibração (3.000) e teste (3.000).
2. Estimação da razão de densidade via **classificador RF**:

   * Rótulo 0 = calibração, 1 = teste.
   * $w(x)=\hat p(x)/(1-\hat p(x))$.
3. Intervalos conformais ponderados.

### 📈 Saídas

* Cobertura empírica e largura média
* Intervalos conformais nas 50 primeiras observações

---

## 💻 Tecnologias Utilizadas

* **Linguagem:** R
* **Pacotes principais:**
  `tidyverse`, `ranger`, `caret`, `MASS`, `mvtnorm`, `patchwork`, `scales`, `showtext`
* **Tema gráfico:** funções customizadas (`theme_econ_base`, `scale_econ`)

---

## ▶️ Como Executar

1. Abra o script desejado (`Estudo Conformal Prediction.R`, `Estudo Covariate Shift.R`, ou `Estudo Covariate Shift (FriedmanDataGeneration).R`).
2. Garanta que todos os pacotes listados estão instalados.
3. Execute o script completo no RStudio.
4. O output incluirá:

   * Métricas de cobertura e largura média
   * Gráficos dos intervalos conformais (50 primeiras observações)
   * Visualizações de densidade (quando aplicável)

---

## 🧠 Reflexão Final

* O **Conformal Prediction clássico** é robusto mas pode gerar intervalos largos.
* O **padronizado** melhora a eficiência em cenários heteroscedásticos.
* O **Quantile RF** traz flexibilidade, calibrando intervalos com melhor adaptação à distribuição condicional.
* Sob **covariate shift**, pesos bem estimados (paramétricos ou via classificação) são cruciais para preservar cobertura, embora intervalos possam se tornar instáveis em shifts extremos.

---

Atenciosamente,
**Hicham Munir Tayfour**
