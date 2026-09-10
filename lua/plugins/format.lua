return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = { "n", "v" }, desc = "Formatar código" },
    { "<leader>uf", function()
      vim.b.disable_autoformat = not vim.b.disable_autoformat
      vim.notify("Formatação ao salvar: " .. (vim.b.disable_autoformat and "desligada" or "ligada"))
    end, desc = "Alternar formatação ao salvar neste arquivo" },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" }, javascriptreact = { "prettier" },
      typescript = { "prettier" }, typescriptreact = { "prettier" },
      html = { "prettier" }, css = { "prettier" }, scss = { "prettier" },
      json = { "prettier" }, jsonc = { "prettier" }, yaml = { "prettier" }, markdown = { "prettier" },
      python = { "ruff_format" },
      go = { "gofmt" }, rust = { "rustfmt" },
      sh = { "shfmt" }, bash = { "shfmt" },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or vim.bo[bufnr].buftype ~= "" then return end
      if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then return end
      return { timeout_ms = 2000, lsp_format = "fallback" }
    end,
  },
}
