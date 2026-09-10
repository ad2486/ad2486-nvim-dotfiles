-- lua/plugins/colorscheme.lua

return {
  "folke/tokyonight.nvim",
  lazy = false,   -- carrega no startup, já que é o tema
  priority = 1000, -- carrega antes dos outros plugins
  config = function()
    require("tokyonight").setup({
      style = "storm", -- "storm" | "night" | "moon" | "day"
      transparent = false,
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
