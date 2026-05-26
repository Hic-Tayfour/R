## APS 1 - Adesão a Produto (Estatística I | 2023.1)

### Objetivo do Trabalho

Este projeto corresponde ao primeiro trabalho de Estatística I da graduação. A análise investiga a **adesão ou não adesão a uma oferta de produto**, a partir de uma base em Excel disponibilizada pelos professores.

O objetivo é descrever o perfil dos clientes, comparar grupos de adesão e não adesão e explorar variáveis associadas ao comportamento observado.

---

### Estrutura do Projeto

- `APSr.R`
  Script principal em R com importação da base, estatísticas descritivas, tabelas e visualizações.

- `v3.xlsx`
  Base de dados utilizada na atividade.

---

### Base de Dados

A base contém informações individuais de clientes e a variável de interesse `subscribed`, que indica se houve adesão à oferta.

Entre as variáveis exploradas no script estão:

- Profissão
- Estado civil
- Idade
- Adesão ou não adesão ao produto

---

### Metodologia

A análise é conduzida por meio de:

- Contagem de clientes que aderiram e não aderiram à oferta
- Proporções por profissão
- Comparações por estado civil
- Estatísticas descritivas da idade
- Tabelas de frequência
- Gráficos de pizza, barras e histogramas

---

### Tecnologias Utilizadas

- Linguagem: **R**
- Pacotes principais:
  - `readxl`
  - `DescTools`

---

### Como Reproduzir

1. Mantenha o arquivo `v3.xlsx` no mesmo diretório do script.

2. Execute o script:

   ```r
   source("APSr.R")
   ```

3. O código retorna tabelas descritivas e gráficos exploratórios sobre adesão ao produto.

---

### Conclusão

O projeto tem caráter introdutório e aplica ferramentas básicas de estatística descritiva para analisar padrões de adesão a uma oferta. A análise organiza os primeiros diagnósticos sobre o perfil dos clientes e suas características observáveis.

Atenciosamente,
**Hicham Tayfour**
