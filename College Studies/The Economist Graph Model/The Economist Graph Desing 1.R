# Pacotes
library(tidyverse)
library(scales)
library(showtext)

# ---- Fonte (fallback simples; troque para sua condensada se tiver) ----
font_family <- if ("Roboto Condensed" %in% systemfonts::system_fonts()$family) "Roboto Condensed" else "sans"
showtext_auto()

# ---- Cores (guia web The Economist) ----
col_bg   <- "#E9EDF0"  # fundo web
col_red  <- "#E3120B"  # Economist Red (se precisar)
col_blue <- "#1270A8"  # azul web (série A)
col_text <- "#0C0C0C"
col_grid <- "#B7C6CF"

# ---- Dados de exemplo ----
set.seed(1)
anos <- 2010:2024
df <- tibble(
  ano = rep(anos, 2),
  valor = c(cumsum(rnorm(15, 0.3, 0.4)) + 11,
            cumsum(rnorm(15, 0.5, 0.5)) + 11.5),
  serie = rep(c("A", "B"), each = length(anos))
)

# ---- Gráfico final (sem retângulo; linhas sem pontos; grade horizontal) ----
p <- ggplot(df, aes(ano, valor, colour = serie)) +
  geom_line(linewidth = 1.1, lineend = "round") +  # sem bolinhas
  scale_colour_manual(values = c("A" = col_blue, "B" = col_red)) +
  scale_x_continuous(breaks = seq(min(df$ano), max(df$ano), by = 5)) +
  labs(
    title = "Exemplo de linha no padrão The Economist",
    subtitle = "Séries fictícias A e B (2010–2024). Unidades no eixo.",
    x = "Ano", y = "Índice", caption = "Fonte: Exemplo sintético"
  ) +
  theme_minimal(base_family = font_family) +
  theme(
    # fundos
    plot.background  = element_rect(fill = col_bg, colour = NA),
    panel.background = element_rect(fill = col_bg, colour = NA),
    
    # títulos à esquerda e tamanhos legíveis
    plot.title.position = "plot",
    plot.title    = element_text(face = "bold", size = 20, hjust = 0, colour = col_text, margin = margin(b = 2)),
    plot.subtitle = element_text(size = 12.5, hjust = 0, colour = col_text, margin = margin(b = 8)),
    plot.caption  = element_text(size = 9, colour = col_text),
    
    # eixos
    axis.title = element_text(size = 11, colour = col_text),
    axis.text  = element_text(size = 10, colour = col_text),
    axis.line.x  = element_line(colour = col_text, linewidth = 0.6),
    axis.ticks.x = element_line(colour = col_text, linewidth = 0.6),
    
    # grade: só horizontal
    panel.grid.major.y = element_line(colour = col_grid, linewidth = 0.4),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    
    # legenda
    legend.position = "top",
    legend.title = element_blank(),
    legend.text  = element_text(size = 10, colour = col_text),
    
    # margens enxutas (sem espaço para bloco)
    plot.margin = margin(t = 16, r = 16, b = 12, l = 16)
  )

# Visualizar / salvar
print(p)
# ggsave("grafico_economist.png", p, width = 10, height = 6, dpi = 300)
