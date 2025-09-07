## 📊 Guia de **Tabelas** no Padrão *The Economist* — R

Olá! Tudo certo por aí?  
Este repositório reúne meu **projeto em RStudio** para criar **tabelas no estilo da revista *The Economist*** usando `gt` e utilitários HTML/SVG leves. A proposta nasce de referências do guia visual da revista e foi organizada em **dois módulos complementares** — um tema base para tabelas “clean” e um construtor para **tabelas com mini-gráficos integrados** (barras, donut, matriz de pontos, etc.).

---

### 📚 O que você encontrará aqui

- 🧩 **Tema e tokens no padrão Economist (para tabelas)**
  - Paleta enxuta e neutros (texto, 75k, fundo “box”, grid/divisor)
  - Título/subtítulo à esquerda; **rótulos em negrito** e **única linha divisória** sob o cabeçalho
  - Versões de tema para:
    - **`one_rule`**: sem grade no corpo; apenas o divisor sob os rótulos (look editorial)
    - **`ruled_body`**: fundo único com **linhas finas entre linhas** (adequado a tabelas com gráficos embutidos)

- 📊 **Tabelas com mini-gráficos integrados**
  - **Barras horizontais duplas** (aplicações/decisões) com rótulos-legenda no cabeçalho  
  - **Donut/anel** com progresso para “Accepted %”  
  - **Barra vermelha segmentada** para “Minimum wait”  
  - **Matriz de pontos em bloco** (3×10) para benefícios/mês  
  - Colunas “texto detalhado” em 75k (*Economist detail*)

- 📝 **Exemplos prontos para colar**
  - Uma tabela “**Greatest hits**” (tema *one_rule*) — look enxuto, sem grades no corpo  
  - Uma tabela “**What to expect**” (tema *ruled_body*) — com **gráficos integrados** e cabeçalho-legenda bicolor  

---

### 📂 Estrutura do repositório

- **`The Economist Table Desing 1.R`**  
  👉 Implementa o **tema base** (*one_rule*), com paleta, tipografia, header em **bold** e **único divisor** sob os rótulos. Inclui exemplo completo de “Greatest hits”.

- **`The Economist Table Desing 2.R`**  
  👉 Constrói a **tabela com gráficos integrados**: helpers para barras, donut, barra segmentada e dot-matrix; **tema *ruled_body*** (linhas finas entre linhas). Traz o exemplo “Asylum processes…”.

---

### 📦 Bibliotecas utilizadas

- **Tabela e renderização:** `gt`, `htmltools`  
- **Manipulação e escalas:** `tidyverse`, `scales`  
- **Tipografia:** `systemfonts` (com fallback limpo; opcionalmente `showtext`)  

Essas libs dão o controle fino necessário sobre **hierarquia visual**, **divisores**, **microtipografia** e **inserção de HTML/SVG** nas células.

---

### 🧠 Como usar (resumo prático)

- Use o tema **`one_rule`** quando quiser o **visual editorial**: **sem grades** no corpo, apenas a **linha sob os rótulos**. Ideal para listas curtas com ênfase tipográfica.  
- Use o tema **`ruled_body`** quando a tabela tiver **elementos gráficos** (barras/donut/pontos) e precisar de **ritmo visual** entre as observações.  
- Para a coluna de barras duplas, o **rótulo do cabeçalho funciona como legenda**:  
  “Applications*” (azul escuro) / “Decisions made” (azul claro), cada qual com sua barra.

---

### 🎯 Objetivo

Servir de **guia prático e reutilizável** para quem deseja publicar **tabelas no estilo *The Economist*** em R — tanto para **relatórios profissionais** quanto para **estudos acadêmicos**. O material foi pensado para ser **autoexplicativo**, com **exemplos comentados** e **temas consistentes** com o manual visual da revista.  

---

Sinta-se à vontade para explorar, adaptar ou complementar com seus próprios estudos!  

Atenciosamente,  

**Hicham Munir Tayfour**  

