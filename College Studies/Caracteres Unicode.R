# Extração de caracteres Unicode

library(Unicode)

get_block_df <- function(block_name, filter_na = FALSE) {
  codes <- as.integer(as.u_char(u_blocks(block_name)[[1]]))
  names <- u_char_name(as.u_char(codes))
  if (filter_na) {
    ok    <- !is.na(names)
    codes <- codes[ok]
    names <- names[ok]
  }
  data.frame(
    codepoint   = sprintf("U+%04X", codes),
    char        = intToUtf8(codes, multiple = TRUE),
    description = names,
    stringsAsFactors = FALSE
  )
}

df_greek <- get_block_df("Greek and Coptic")

df_math  <- get_block_df("Mathematical Operators", filter_na = TRUE)

print(df_greek)
print(df_math)

# Usos

## Uso em texto

cat("Símbolo ∀ (por todo):", "\u2200", "\n")

## Uso em gráficos 

library(ggplot2)

set.seed(42)
df <- data.frame(
  x = rnorm(100),
  y = rnorm(100)
)

ggplot(df, aes(x = x, y = y)) +
  geom_point() +
  labs(
    title    = "Distribuição de Valores: \u03BC = 0, \u03C3 = 1",    
    subtitle = "Exemplo com \u03B1, \u03B2 e \u2211",              
    x        = "Eixo X: \u03B1 (alpha)",                           
    y        = "Eixo Y: \u03B2 (beta)"                            
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title    = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 12),
    axis.text.x   = element_text(color = "darkred"),
    axis.text.y   = element_text(color = "darkgreen")
  )
