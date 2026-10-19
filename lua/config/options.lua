-- lua/config/options.lua
-- Opções gerais. Leader precisa ser setado ANTES do lazy.nvim carregar os plugins.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Desliga o netrw (vamos usar nvim-tree como explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

opt.mouse = "a"
opt.clipboard = "unnamedplus" -- usa o clipboard do sistema (macOS: pbcopy/pbpaste; Wayland: wl-clipboard)
opt.termguicolors = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

-- Mantém os blocos abertos inicialmente; za/zc/zo continuam disponíveis.
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.scrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 400

opt.undofile = true -- histórico de undo persistente entre sessões
opt.swapfile = false
opt.backup = false

opt.wrap = false
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
