-- lua/plugins/editor.lua
-- Um punhado de plugins pequenos que fazem o editor parecer "IDE".

return {
  -- Fecha parênteses/aspas/colchetes automaticamente
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- gc / gcc pra comentar linhas
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Mostra os keybindings disponíveis enquanto você digita
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Linhas guia de indentação
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
