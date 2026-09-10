return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      "stylua", "prettier", "ruff", "shfmt", "shellcheck", "eslint-lsp",
      "debugpy", "delve", "codelldb", "js-debug-adapter",
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
    integrations = { ["mason-lspconfig"] = false, ["mason-null-ls"] = false, ["mason-nvim-dap"] = false },
  },
}
