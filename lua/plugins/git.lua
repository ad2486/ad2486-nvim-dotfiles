-- lua/plugins/git.lua

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", gs.next_hunk, "Próxima alteração (git)")
      map("n", "[h", gs.prev_hunk, "Alteração anterior (git)")
      map("n", "<leader>hp", gs.preview_hunk, "Preview da alteração (git)")
      map("n", "<leader>hb", gs.blame_line, "Blame da linha")
    end,
  },
}
