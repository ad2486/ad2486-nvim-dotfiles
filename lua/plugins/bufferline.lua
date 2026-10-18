-- lua/plugins/bufferline.lua
-- Abas no topo, estilo navegador (uma aba por arquivo aberto).

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Próxima aba" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Aba anterior" },
    { "<leader>bd", "<cmd>bdelete<CR>", desc = "Fechar aba" },
    { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Escolher aba" },
  },
  opts = {
    options = {
      offsets = { { filetype = "NvimTree", text = "Arquivos", separator = true } },
    },
  },
}
