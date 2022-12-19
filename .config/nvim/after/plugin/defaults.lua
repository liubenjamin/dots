vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 10

vim.keymap.set("n", "<leader>rw", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", ";", vim.cmd.HopWord)
vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader><space>", "zz")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set('n', '<leader>/', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>z', require('zen-mode').toggle)
vim.keymap.set('n', '<C-t>', vim.cmd.tabnew)
vim.keymap.set('n', '<leader>n', vim.cmd.tabnext)
vim.keymap.set('n', '<leader>p', vim.cmd.tabprevious)
vim.keymap.set('n', '<leader>q', vim.cmd.q)

vim.cmd.colorscheme("catppuccin-mocha")
