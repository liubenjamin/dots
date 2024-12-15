vim.o.scrolloff = 10
vim.o.relativenumber = true

local hop = require 'hop'
vim.keymap.set('n', ';', hop.hint_words)
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('i', 'kj', '<esc>', { noremap = true })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')
vim.keymap.set('n', '<leader>n', '<cmd>tabprev<cr>')
vim.keymap.set('n', '<leader>p', '<cmd>tabnext<cr>')
vim.api.nvim_create_autocmd('VimLeave', { command = 'set guicursor=a:ver10-blinkon1-blinkwait10' })
vim.cmd.colorscheme 'catppuccin-macchiato'
