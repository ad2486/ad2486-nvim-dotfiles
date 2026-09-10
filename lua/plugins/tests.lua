return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python", "fredrikaverpil/neotest-golang", "rouge8/neotest-rust",
    "marilari88/neotest-vitest", "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Teste mais próximo" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%:p")) end, desc = "Testes deste arquivo" },
    { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Testes do diretório atual" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Repetir último teste" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Painel de testes" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Resultado do teste" },
    { "<leader>tq", function() require("neotest").run.stop() end, desc = "Parar teste" },
    { "<leader>td", function()
      require("lazy").load({ plugins = { "nvim-dap" } })
      require("neotest").run.run({ strategy = "dap" })
    end, desc = "Depurar teste mais próximo" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({ dap = { justMyCode = false } }),
        require("neotest-golang")({}),
        require("neotest-rust")({}),
        require("neotest-vitest")({}),
        require("neotest-jest")({
          -- A descoberta padrão usa glob em callback assíncrono, incompatível
          -- com Neovim 0.12. vim.fs também reconhece configurações CJS/MJS.
          jestConfigFile = function(path)
            local dir = vim.fs.dirname(path)
            return vim.fs.find({
              "jest.config.js", "jest.config.ts", "jest.config.cjs",
              "jest.config.mjs", "jest.config.cts", "jest.config.mts",
            }, { path = dir, upward = true })[1]
              or vim.fs.find("package.json", { path = dir, upward = true })[1]
          end,
        }),
      },
      discovery = { filter_dir = function(name)
        return not vim.tbl_contains({ "node_modules", ".git", "target", ".venv", "venv", "dist", "build" }, name)
      end },
    })
  end,
}
