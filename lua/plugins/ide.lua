return {
  {
    "folke/which-key.nvim",
    opts = { spec = {
      { "<leader>c", group = "Código" }, { "<leader>t", group = "Testes" },
      { "<leader>v", group = "Depuração" }, { "<leader>g", group = "Git" },
      { "<leader>u", group = "Preferências" }, { "<leader>x", group = "Diagnósticos" },
    } },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>xx", function() require("telescope.builtin").diagnostics() end, desc = "Diagnósticos do projeto" },
      { "<leader>cs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Símbolos do arquivo" },
    },
  },
}
