vim.g.mapleader = " "

-- Terminal
vim.keymap.set('t', '<A-q>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>tt', ':tabnew | terminal<CR>i')
vim.keymap.set('n', '<leader>tv', ':rightbelow vsplit | terminal<CR>i')
vim.keymap.set('n', '<leader>th', ':rightbelow split | terminal<CR>i')

-- Tabs And Splits
vim.keymap.set('n', '<leader>st', ':tabnew<CR>')
vim.keymap.set('n', '<leader>sv', ':rightbelow vsplit<CR>')
vim.keymap.set('n', '<leader>sh', ':rightbelow split<CR>')

-- Navigation
vim.keymap.set("n", "-", vim.cmd.Oil)
vim.keymap.set('n', '<leader>b', '<c-^>\""zz', { silent = true, noremap = true })
vim.keymap.set('n', '<Tab>', '<C-w>w')
vim.keymap.set('n', '<S-Tab>', 'gt')

-- Clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<C-c>', '"+y', { desc = 'yank to clipboard' })

-- Editing
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc>:w<CR>', { desc = 'Save file' })
