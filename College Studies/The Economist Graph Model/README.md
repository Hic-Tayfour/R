##  Guia de Gráficos no Padrão *The Economist* — R  

Olá! Espero que esteja tudo bem com você.  
Neste repositório, compartilho meu **projeto em RStudio** dedicado a recriar e padronizar **gráficos no estilo da revista *The Economist***.  

O trabalho foi construído a partir do manual visual da revista, com **funções utilitárias, paletas oficiais e exemplos comentados**.  
No final, organizei tudo em um **arquivo RMarkdown seccionado**, que funciona como um guia prático e ilustrado.  

---

###  O que você encontrará aqui:

-  **Tema base e paletas oficiais**  
  - Cores principais, secundárias, de suporte e neutras  
  - Funções auxiliares de escala (`scale_fill_econ`, `scale_colour_econ`)  
  - Tema unificado (`theme_econ_base`)  

-  **Funções utilitárias por tipo de gráfico**  
  - Barras (lado a lado / empilhadas / 100%)  
  - Linhas (lado a lado / empilhadas)  
  - Termômetro (hastes + pontos / dot terminals)  
  - Dispersão & Bubble (incluindo highlight e tendência)  
  - Pizza & Rosca (com “Outros” em cinza e texto central)  
  - Timelines (séries + períodos + eventos)  

-  **Exemplos comentados**  
  - Cada função vem acompanhada de exemplos com dados sintéticos  
  - Resumos explicativos: *quando usar, dicas e boas práticas*  

---

###  Estrutura do repositório

- `The Economist Graph Desing 1.R`  
   Protótipo inicial com gráfico de linha, fundo no padrão Economist e bloco vermelho acima do título.  

- `The Economist Graph Desing 2.R`  
   Expansão para todas as **paletas de cores oficiais**, tokens (`econ_base`), escalas auxiliares e definição do **tema unificado**.  

- `The Economist Graph Desing 3`  
   Implementação das funções `econ_*` para cada tipo de gráfico (barras, linhas, áreas, termômetro, scatter, pie, timeline) + exemplos sintéticos.  

- `The Economist Graph Desing 4.Rmd`  
   Documento final, com seções organizadas, **resumos de uso/dicas** e todos os gráficos reproduzidos no padrão *The Economist*.  
   Relatório HTML disponível em: [ver aqui](https://raw.githack.com/Hic-Tayfour/HTML/refs/heads/main/The-Economist-Graph-Desing-4.html)

---

###  Bibliotecas utilizadas

- **Visualização e manipulação:** `tidyverse`, `scales`, `forcats`  
- **Tipografia:** `showtext`, `systemfonts`  
- **Estética adicional:** `grid` (para setas e caixas em timelines)  

Esses pacotes permitiram padronizar tanto os gráficos quanto o fluxo de trabalho.  

---

###  Objetivo

Este projeto serve como um **guia prático e reutilizável** para quem deseja aplicar o estilo *The Economist* em análises no R.  
Ele funciona tanto como **material de estudo pessoal** quanto como **base para relatórios profissionais e acadêmicos**.  

---

Sinta-se à vontade para explorar, adaptar ou complementar com seus próprios estudos!  

Atenciosamente,  

**Hicham Munir Tayfour**  
