# Neovim — configuração pessoal

Configuração modular em Lua para uma experiência de IDE: navegação por código,
autocomplete, sugestões de IA, formatação, lint, depuração, testes e Git.

Validada em **macOS Apple Silicon com Neovim 0.12.5**. O tema é **Tokyo Night Storm**
e a tecla leader é **Espaço**. Não usa uma distribuição pronta como LazyVim.

## Conteúdo

- [Instalação e requisitos](#instalação-e-requisitos)
- [Organização dos arquivos](#organização-dos-arquivos)
- [Linguagens e ferramentas](#linguagens-e-ferramentas)
- [Código e formatação](#código-e-formatação)
- [Depuração](#depuração)
- [Testes](#testes)
- [Git e navegação](#git-e-navegação)
- [Autocomplete e Windsurf](#autocomplete-e-windsurf)
- [Atalhos de edição e LSP](#atalhos-de-edição-e-lsp)
- [Manutenção e personalização](#manutenção-e-personalização)
- [Solução de problemas](#solução-de-problemas)

## Instalação e requisitos

### Ferramentas do sistema

| Dependência | Uso |
|---|---|
| Neovim 0.12+ | Versão exigida pela branch `main` do Treesitter instalado |
| Git | Instalação de plugins e integração com repositórios |
| `rg` (ripgrep) e `fd` | Busca de texto e arquivos |
| `tree-sitter` CLI 0.26.1+ | Compilação de parsers; instalar pelo gerenciador do sistema, não npm |
| Compilador C, make, curl, tar e unzip | Compilação e instalação de dependências |
| Node.js e npm | Servidores web, Prettier, ESLint e debugger JavaScript |
| Python 3 | Ferramentas Python e ambiente Hererocks |
| Go | gopls, gofmt, testes e depuração Go |
| Rust/Cargo, rustfmt e rust-src | Rust Analyzer, formatação e depuração Rust |
| cargo-nextest | Execução de testes Rust no Neotest |
| LazyGit | Interface Git no terminal integrado |
| Google Chrome | Opção de depuração de frontend |

Uma Nerd Font no terminal é recomendada para os ícones. Use um terminal com true color.
No macOS, o clipboard usa `pbcopy`/`pbpaste`. Em outros sistemas, configure o provedor
adequado. Os caminhos dos adaptadores Python assumem ambiente Unix (`venv/bin/python`);
Windows exige adaptação. As demais plataformas não foram validadas.

### Colocar a configuração no lugar

O diretório de configuração padrão é `~/.config/nvim`. Se ele já existir em outra
máquina, preserve-o antes de substituí-lo. Depois de publicar este repositório,
clone-o nesse diretório usando a URL que você escolher:

```sh
git clone <URL_DO_REPOSITORIO> ~/.config/nvim
nvim
```

Na primeira abertura, o Lazy instala os plugins, o Mason instala as ferramentas
configuradas e o Treesitter instala os parsers. Aguarde as instalações terminarem.
O clone acima é apenas um modelo: nenhum remote é definido por esta configuração.

Para usar as versões de plugins registradas neste repositório e conferir as ferramentas:

```vim
:Lazy restore
:MasonToolsInstall
:checkhealth lazy conform dap
```

Servidores de linguagem ficam em `lsp.lua`; o `mason-lspconfig` instala os ausentes
na abertura interativa. `MasonToolsInstall` cuida da lista adicional de formatadores,
linters e depuradores em `tools.lua`. Go, Rust, cargo-nextest e LazyGit são dependências
do sistema, não são instalados por esse comando.

### LuaRocks / Hererocks

Nesta máquina, **Lua 5.1.5 e LuaRocks 3.13.0** estão instalados no ambiente
`~/.local/share/nvim/lazy-rocks/hererocks`. O suporte do Lazy permanece habilitado.
Esse ambiente não faz parte do repositório. Para recriá-lo em outra máquina, o fluxo
usado foi o instalador oficial Hererocks (o destino deve corresponder ao diretório
de dados do Neovim quando houver personalização de XDG):

```sh
git clone https://github.com/luarocks/hererocks.git /tmp/nvim-hererocks
python3 /tmp/nvim-hererocks/hererocks.py -l 5.1 -r latest ~/.local/share/nvim/lazy-rocks/hererocks
```

Nenhum plugin da configuração validada exige LuaRocks no momento; a instalação
permite adicionar plugins que precisem dele. `latest` pode instalar uma versão mais
nova do LuaRocks em outra data.

### Windsurf e dependências dos projetos

Execute `:Codeium Auth` para autenticar o Windsurf na nova máquina.
A configuração dos atalhos é versionada; a autenticação não é incluída neste repositório.

Instale também as dependências de cada projeto com seu gerenciador habitual.
ESLint, seus plugins, Jest, Vitest e pytest não são impostos globalmente.
Para Python, abra o Neovim com o ambiente virtual do projeto disponível; as integrações
também procuram ambientes locais como `.venv`.

## Organização dos arquivos

```text
.
├── .gitignore
├── README.md
├── init.lua
├── lazy-lock.json
└── lua/
    ├── config/
    │   ├── lazy.lua        # Bootstrap e carregamento de plugins
    │   ├── options.lua     # Leader, aparência, indentação e folding
    │   ├── keymaps.lua     # Atalhos gerais, terminal e LazyGit
    │   └── autocmds.lua    # Yank, cursor e criação de diretórios
    └── plugins/
        ├── cmp.lua         # Autocomplete e snippets
        ├── colorscheme.lua # Tokyo Night Storm
        ├── debug.lua       # DAP, painéis e configurações por linguagem
        ├── editor.lua      # Comentários, pares, guias e which-key
        ├── explorer.lua    # Árvore de arquivos
        ├── format.lua      # Conform e formatação ao salvar
        ├── git.lua         # Gitsigns
        ├── ide.lua         # Grupos de atalhos, diagnósticos e símbolos
        ├── lsp.lua         # Servidores, capacidades e atalhos LSP
        ├── lualine.lua     # Barra de status
        ├── telescope.lua   # Buscas
        ├── tests.lua       # Neotest e adaptadores
        ├── tools.lua       # Ferramentas gerenciadas pelo Mason
        ├── treesitter.lua  # Parsers, destaque, indentação e folding
        └── windsurf.lua    # Sugestões de IA
```

O `init.lua` carrega opções, atalhos, autocmds e depois o Lazy. Arquivos em
`lua/plugins/` são importados automaticamente. O `lazy-lock.json` deve ser versionado:
ele registra os commits dos plugins, mas **não fixa as versões das ferramentas do
Mason, dos parsers ou das dependências do sistema**.

Plugins e dependências auxiliares ficam em `~/.local/share/nvim`; logs e estado,
em `~/.local/state/nvim`; caches, em `~/.cache/nvim` nas configurações XDG padrão.
Esses diretórios não pertencem ao repositório de configurações.

## Linguagens e ferramentas

| Linguagem | LSP / lint | Formatação | Depuração | Testes |
|---|---|---|---|---|
| JavaScript / TypeScript / JSX / TSX | ts_ls + ESLint quando configurado no projeto | Prettier | Node / Chrome | Jest / Vitest |
| Python | Pyright + Ruff | Ruff | debugpy | pytest / unittest |
| Go | gopls | gofmt | Delve | go test |
| Rust | rust-analyzer | rustfmt | CodeLLDB | cargo-nextest |
| Lua | lua_ls | StyLua | — | — |
| HTML / CSS | html / cssls | Prettier | — | — |
| JSON | jsonls | Prettier | — | — |
| YAML | yamlls | Prettier | — | — |
| Bash / sh | bashls com ShellCheck disponível | shfmt | — | — |
| Markdown | — | Prettier | — | — |

O Treesitter carrega na inicialização e inclui parsers de Lua, Vim, help, query,
JS/TS/TSX, Python, HTML, CSS, JSON, Bash, Markdown, YAML, Rust e Go. JSX usa o filetype
`javascriptreact`. Instalar um parser não instala o servidor LSP correspondente.

## Código e formatação

| Atalho | Ação |
|---|---|
| Salvar (`:w` ou Espaço w) | Formata automaticamente |
| Espaço cf | Formatar arquivo ou seleção |
| Espaço uf | Ligar/desligar formatação ao salvar no arquivo atual |
| Espaço ca | Ações de código, incluindo correções oferecidas pelo linter |
| Espaço d | Diagnóstico da linha |
| Espaço xx | Buscar diagnósticos conhecidos pelo Neovim |
| Espaço cs | Buscar símbolos do arquivo |
| Ctrl+l / Ctrl+h | Avançar/voltar entre campos de snippets |
| Tab | Aceitar sugestão do Windsurf |

Formatadores: Prettier (JS/TS/JSX/TSX, HTML, CSS, JSON, YAML e Markdown),
Ruff (Python), StyLua (Lua), gofmt (Go), rustfmt (Rust) e shfmt (shell).
Prettier prefere a instalação local do projeto. Os formatadores leem suas configurações habituais.
`Espaço uf` afeta somente o buffer atual, durante a sessão.

Ruff fornece lint Python junto ao Pyright. ESLint entra nos projetos com configuração ESLint;
a biblioteca ESLint e seus plugins devem estar nas dependências do projeto.
ShellCheck fica disponível ao servidor Bash. YAML continua com validação pelo servidor YAML.

## Depuração

| Atalho | Ação |
|---|---|
| F5 ou Espaço vc | Iniciar/continuar |
| F9 ou Espaço vb | Marcar/remover breakpoint |
| F10 ou Espaço vo | Executar próxima linha sem entrar na função |
| F11 ou Espaço vi | Entrar na função |
| Shift+F11 ou Espaço vO | Sair da função |
| Espaço vu | Abrir/fechar painel de variáveis, pilha e console |
| Espaço ve | Avaliar expressão ou seleção |
| Espaço vq | Encerrar sessão |

No teclado do Mac, pode ser necessário usar Fn com as teclas F. Os atalhos com Espaço evitam isso.

- **Python:** debugpy; a integração procura o ambiente virtual do projeto.
- **Go:** Delve; escolha executar o pacote ou depurar testes.
- **Rust:** CodeLLDB. Execute `cargo build` e selecione o executável em `target/debug/`.
- **Node:** executar arquivo JS ou conectar a um processo iniciado com `--inspect`.
- **TypeScript:** conectar ao processo do projeto com `--inspect`, usando o runner/build do projeto e source maps.
- **Frontend:** inicie o servidor de desenvolvimento, escolha “Frontend: abrir Chrome” e informe a URL.
- Configurações específicas podem ficar no `.vscode/launch.json` do projeto, lido pelo nvim-dap.

## Testes

| Atalho | Ação |
|---|---|
| Espaço tt | Executar teste mais próximo |
| Espaço tf | Executar testes do arquivo |
| Espaço ta | Executar testes do diretório atual |
| Espaço tl | Repetir último teste |
| Espaço ts | Abrir/fechar painel de testes |
| Espaço to | Ver saída do teste |
| Espaço td | Depurar teste (quando o adaptador oferece suporte) |
| Espaço tq | Parar execução |

Adaptadores: Python (pytest/unittest), Go, Rust (cargo-nextest), Vitest e Jest.
Pytest, Vitest e Jest devem existir no ambiente/dependências do projeto que os utiliza.
O runner Rust cargo-nextest já foi instalado. Os testes não são disparados automaticamente ao salvar.

## Git e navegação

| Atalho | Ação |
|---|---|
| Espaço gg | Abrir LazyGit na raiz do repositório |
| q dentro do LazyGit | Sair do LazyGit |
| Esc Esc dentro do terminal | Voltar ao modo normal do Neovim |
| Espaço ee / Espaço ef | Explorer / localizar arquivo atual |
| za / zc / zo | Alternar / fechar / abrir bloco de código |

## Autocomplete e Windsurf

O nvim-cmp oferece itens do LSP, snippets, texto de buffers e caminhos. LuaSnip
expande os snippets de `friendly-snippets`. O Windsurf oferece sugestões em ghost text.

| Atalho no modo de inserção | Ação |
|---|---|
| Ctrl+Espaço | Abrir menu de autocomplete |
| Ctrl+n / Ctrl+p | Próximo / anterior item do menu |
| Enter | Confirmar item explicitamente selecionado |
| Ctrl+e | Fechar o menu |
| Ctrl+l / Ctrl+h | Próximo / anterior campo de snippet, também no modo de seleção |
| Tab | Aceitar sugestão do Windsurf |
| Ctrl+; / Ctrl+, | Próxima / anterior sugestão do Windsurf |
| Ctrl+x | Descartar sugestão do Windsurf |

Fora de um snippet, Ctrl+l/Ctrl+h usam o comportamento anterior. No modo normal,
Ctrl+h/j/k/l navegam entre janelas. Alguns terminais não distinguem todas as combinações
com pontuação; nesse caso ajuste somente os atalhos em `windsurf.lua`.

## Atalhos de edição e LSP

As letras diferenciam maiúsculas e minúsculas. Atalhos LSP são criados quando um
servidor se conecta ao buffer. Pressione Espaço e aguarde o which-key para descobrir
os atalhos disponíveis.

| Atalho | Ação |
|---|---|
| Espaço w / Espaço q | Salvar / fechar janela |
| Ctrl+h/j/k/l | Focar janela à esquerda/abaixo/acima/direita |
| Esc | Limpar destaque de busca no modo normal |
| Ctrl+d / Ctrl+u | Rolar meia página mantendo cursor centralizado |
| n / N | Próxima / anterior ocorrência, centralizando cursor |
| J / K no modo visual | Mover seleção para baixo / cima |
| < / > no modo visual | Indentar mantendo a seleção |
| gcc / gc | Comentar linha / movimento ou seleção |
| gd / gD | Definição / declaração |
| gr / gI | Referências / implementação |
| K | Documentação do símbolo |
| Espaço rn | Renomear símbolo |
| Espaço D | Definição de tipo |
| [d / ]d | Diagnóstico anterior / próximo |
| Espaço ff / Espaço fg | Buscar arquivos / texto no projeto |
| Espaço fb / Espaço fr | Buffers abertos / arquivos recentes |
| Espaço fh | Buscar ajuda |
| Ctrl+j / Ctrl+k no Telescope | Próximo / anterior resultado |
| [h / ]h | Alteração Git anterior / próxima |
| Espaço hp / Espaço hb | Prévia da alteração / blame da linha |

Comportamentos gerais: números relativos, mouse e clipboard habilitados, duas
colunas de indentação por padrão, espaços em vez de tabs (filetypes podem sobrescrever),
sem quebra visual de linha, undo persistente e swap/backup desativados. Blocos começam
abertos; folding continua disponível. A posição do cursor é restaurada ao reabrir
arquivos e diretórios ausentes são criados ao salvar um caminho novo.

## Manutenção e personalização

| Comando | Uso |
|---|---|
| `:Lazy` | Inspecionar plugins e operações disponíveis |
| `:Lazy update` | Atualizar plugins; revisar as mudanças no lockfile |
| `:Lazy restore` | Restaurar versões registradas no lockfile |
| `:Mason` | Inspecionar servidores e ferramentas |
| `:MasonToolsInstall` | Instalar ferramentas ausentes da lista de tools.lua |
| `:MasonToolsUpdate` | Atualizar ferramentas dessa lista |
| `:TSUpdate` | Atualizar parsers, especialmente após atualizar Treesitter |
| `:ConformInfo` | Inspecionar formatadores disponíveis e log |
| `:checkhealth lazy conform dap` | Verificar componentes principais |
| `:checkhealth vim.lsp` | Inspecionar servidores habilitados e clientes ativos |
| `:checkhealth nvim-treesitter` | Verificar parsers e compilação |
| `:checkhealth neotest-golang` | Verificar integração Go dentro de um módulo Go |
| `:messages` | Rever mensagens recentes |

A checagem de atualizações do Lazy está habilitada, sem notificações. O
mason-tool-installer instala ausentes ao iniciar, com atraso de 3 segundos, mas
não faz atualização automática.

Para adicionar uma linguagem, configure o servidor em `lsp.lua`, o parser e filetype
em `treesitter.lua`, o formatador em `format.lua` e seu instalador em `tools.lua`
quando necessário. Debuggers e runners de testes são configurados separadamente.

Para alterar atalhos, edite o arquivo do recurso. Preserve Tab para Windsurf e
`Espaço d` para diagnóstico: isso evita colidir com o prefixo `Espaço ee/ef` do explorer.
O toggle `Espaço uf` desativa autoformatação apenas no buffer durante a sessão;
para mudar o padrão, edite `format_on_save` em `format.lua`.

## Solução de problemas

- **Sem autocomplete/definição:** confira o filetype e `:checkhealth vim.lsp`.
  O servidor precisa estar instalado e identificar a raiz do projeto.
- **ESLint não mostra erros:** confirme configuração e dependências ESLint no projeto.
  Não há instalação global das regras de cada projeto.
- **Python usa outro ambiente:** abra o Neovim com o venv correto ativado ou mantenha
  o ambiente em `.venv`; confira as configurações do projeto e o executável escolhido.
- **Sem formatação:** use `:ConformInfo`, confira a instalação e o toggle `Espaço uf`.
  A formatação ao salvar tem timeout de 2 segundos e usa LSP como fallback.
- **Sem testes:** instale o runner do projeto, confira os parsers e abra o Neovim
  na raiz apropriada. `Espaço ta` usa o diretório atual. Diretórios como `.venv`,
  `node_modules`, `target`, `dist` e `build` são excluídos da descoberta.
- **Jest no Neovim 0.12:** `tests.lua` usa `vim.fs` na descoberta da configuração para
  evitar `glob` em callbacks assíncronos; inclui arquivos CJS/MJS/CTS/MTS.
- **Debugger frontend:** o servidor de desenvolvimento precisa estar rodando na URL
  informada; source maps e a configuração de execução pertencem ao projeto.
- **Debugger Rust:** compile primeiro e selecione o binário, não o arquivo `.rs`.
  CodeLLDB tem timeout de inicialização de 30 segundos.
- **Debugger Node no macOS:** cliente e servidor estão configurados explicitamente
  para `127.0.0.1`, evitando diferenças entre IPv4 e IPv6 de `localhost`.
- **Ícones incorretos:** selecione uma Nerd Font nas configurações do terminal.
- **Aviso de LuaRocks em outra máquina:** recrie o ambiente Hererocks descrito acima.
- **`No healthcheck found` para `neotest`:** o plugin não oferece esse check genérico
  na versão validada; execute um teste ou o healthcheck de um adaptador que o forneça.

## Validação da configuração

Na montagem desta configuração foram verificados, em projetos temporários:

- Formatação ao salvar em Lua, JS, Python, Go, Rust, shell e YAML.
- Diagnósticos Ruff e ESLint.
- Breakpoints em Python, Node, Go e Rust.
- Execução de testes Python, Go, Rust, Vitest e Jest pelo Neotest.
- Abertura de LazyGit e dos painéis; preservação do Tab do Windsurf.

A configuração de Chrome foi adicionada, mas o fluxo de frontend não foi validado
num projeto real. Os exemplos temporários de validação não fazem parte deste repositório.

## Referências

- [Neovim](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Mason](https://github.com/mason-org/mason.nvim)
- [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)
- [Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [Conform](https://github.com/stevearc/conform.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [Neotest](https://github.com/nvim-neotest/neotest)
- [Windsurf](https://github.com/Exafunction/windsurf.vim)
- [Hererocks](https://github.com/luarocks/hererocks)
