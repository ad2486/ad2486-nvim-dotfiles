-- lua/plugins/telescope.lua

return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Buscar arquivos" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Buscar texto no projeto" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buscar buffers abertos" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Buscar help tags" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Arquivos recentes" },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      sorting_strategy = "ascending",
      mappings = {
        i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
      },
    },
  },
}
