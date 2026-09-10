-- lua/plugins/explorer.lua

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ee", "<cmd>NvimTreeToggle<CR>", desc = "Abrir/fechar explorer" },
    { "<leader>ef", "<cmd>NvimTreeFindFile<CR>", desc = "Localizar arquivo atual no explorer" },
  },
  opts = {
    view = { width = 32 },
    renderer = { group_empty = true },
    filters = { dotfiles = false },
  },
}
