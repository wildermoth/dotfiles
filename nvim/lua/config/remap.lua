vim.g.mapleader = " "

vim.keymap.set('t', '<C-k>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>')

-- Navigation
vim.keymap.set("n", "-", vim.cmd.Oil)
vim.keymap.set('n', '<leader>b', "<C-^>")
