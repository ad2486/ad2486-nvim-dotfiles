-- lua/plugins/lsp.lua
-- LSP de verdade: mason instala os language servers, mason-lspconfig conecta
-- eles ao nvim-lspconfig e habilita automaticamente (API nova do Neovim 0.11+).

return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      -- Servers instalados automaticamente. Adicione o que precisar
      -- (lista completa: :Mason ou https://github.com/mason-org/mason-lspconfig.nvim)
      ensure_installed = {
        "lua_ls",     -- Lua
        "ts_ls",      -- JavaScript/TypeScript
        "pyright",    -- Python
        "html",
        "cssls",
        "jsonls",
        "bashls",
        "gopls",         -- Go
        "rust_analyzer", -- Rust
        "yamlls",        -- YAML
        "ruff",          -- Lint Python
        "eslint",        -- Lint JS/TS com as regras do projeto
      },
      automatic_enable = true,
    },
    config = function(_, opts)
      -- Capabilities extras pro nvim-cmp (autocomplete de LSP: funções, imports etc.)
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Um pouco mais de conforto pro lua_ls quando editando a própria config do Neovim
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- Pyright cuida de tipos/hover; Ruff fornece lint e ações de correção.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ruff-capabilities", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == "ruff" then client.server_capabilities.hoverProvider = false end
        end,
      })
      require("mason-lspconfig").setup(opts)

      -- Keymaps de LSP só ficam ativos no buffer onde um LSP realmente anexou
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Ir pra definição")
          map("n", "gD", vim.lsp.buf.declaration, "Ir pra declaração")
          map("n", "gr", vim.lsp.buf.references, "Ver referências")
          map("n", "gI", vim.lsp.buf.implementation, "Ir pra implementação")
          map("n", "K", vim.lsp.buf.hover, "Ver documentação (hover)")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>D", vim.lsp.buf.type_definition, "Ir pra definição de tipo")
          map("n", "<leader>d", vim.diagnostic.open_float, "Ver diagnóstico da linha")
          map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Diagnóstico anterior")
          map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Próximo diagnóstico")
        end,
      })
    end,
  },
}
