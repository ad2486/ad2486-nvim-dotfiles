-- lua/config/keymaps.lua
-- Keymaps gerais. Keymaps de plugin específico ficam no arquivo do próprio plugin.

local map = vim.keymap.set

-- Navegação entre janelas
map("n", "<C-h>", "<C-w>h", { desc = "Foca janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Foca janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Foca janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Foca janela à direita" })

-- Limpar highlight de busca
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpa highlight de busca" })

-- Salvar / sair rápido
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fechar janela" })

-- Mover linha(s) selecionada(s) pra cima/baixo no visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move seleção pra baixo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move seleção pra cima" })

-- Mantém o cursor centralizado ao rolar meia página ou pular busca
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Indentação no visual mode sem perder a seleção
map("v", "<", "<gv")
map("v", ">", ">gv")


-- Terminal integrado para Git, aberto na raiz do repositório atual.
map("n", "<leader>gg", function()
  local cwd = vim.fs.root(0, ".git") or vim.fn.getcwd()
  vim.cmd("botright new")
  vim.fn.jobstart({ "lazygit" }, {
    term = true, cwd = cwd,
    on_exit = function(_, code)
      if code ~= 0 then vim.schedule(function() vim.notify("LazyGit encerrou com código " .. code, vim.log.levels.WARN) end) end
    end,
  })
  vim.cmd("startinsert")
end, { desc = "Abrir LazyGit" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Sair do modo terminal" })
