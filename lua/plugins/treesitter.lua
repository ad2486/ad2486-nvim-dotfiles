-- lua/plugins/treesitter.lua
-- OBS: desde que o nvim-treesitter reescreveu a branch "main" (que virou o
-- default do repo), o módulo "nvim-treesitter.configs" e o .setup({ensure_installed=...})
-- não existem mais. Agora instala parser com .install() e liga highlight/indent
-- na mão via autocmd de FileType (nome do filetype às vezes difere do nome do
-- parser: bash -> sh, tsx -> typescriptreact, vimdoc -> help).

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false, -- A branch main não suporta lazy-loading.
  config = function()
    -- Adicione outros parsers aqui conforme for precisando
    local parsers = {
      "lua", "vim", "vimdoc", "query",
      "javascript", "typescript", "tsx",
      "python", "html", "css", "json",
      "bash", "markdown", "markdown_inline",
      "yaml", "rust", "go", "c",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-setup", { clear = true }),
      pattern = {
        "lua", "vim", "help", "query",
        "javascript", "javascriptreact", "typescript", "typescriptreact",
        "python", "html", "css", "json",
        "sh", "bash", "markdown",
        "yaml", "rust", "go", "c",
      },
      callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
