-- lua/plugins/colorscheme.lua

return {
  "vague-theme/vague.nvim",
  lazy = false,   -- carrega no startup, já que é o tema
  priority = 1000, -- carrega antes dos outros plugins
  config = function()
    require("vague").setup({
      transparent = false,
    })
    vim.cmd.colorscheme("vague")
  end,
}
