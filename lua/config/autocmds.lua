-- lua/config/autocmds.lua

-- Dá um highlight rápido no texto copiado (yank)
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight ao copiar texto",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Volta pro último lugar em que o cursor estava ao reabrir um arquivo
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restaura posição do cursor",
  group = vim.api.nvim_create_augroup("restore-cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Cria a pasta de destino automaticamente ao salvar um arquivo novo em path inexistente
vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Cria diretórios ao salvar se necessário",
  group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
