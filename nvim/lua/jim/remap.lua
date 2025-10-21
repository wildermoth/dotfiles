vim.g.mapleader = " "
vim.keymap.set("n", "-", vim.cmd.Oil)
vim.keymap.set("n", "<leader>rr", ":w<CR>:!python %<CR>", { silent = true })
vim.keymap.set("n", "<leader>rt", ":w<CR>:split | terminal python %<CR>", { silent = true })


vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])

vim.keymap.set("n", "<leader>al", function()
    local cwd = vim.fn.getcwd()
    -- Launch alacritty in cwd

    vim.fn.jobstart({ "alacritty", "--working-directory", cwd }, { detach = true })
end, { desc = "Open Alacritty in project root" })
vim.keymap.set('n', '<leader>b', "<C-^>")
-- In your init.lua or a lua/plugin file
-- <leader>lg → open 25% vsplit terminal and run `git lg`
vim.keymap.set("n", "<leader>lg", function()
    -- Find repo root
    local start_dir = vim.fn.expand("%:p:h")
    if start_dir == "" then start_dir = vim.loop.cwd() end
    local git_dir = vim.fs.find(".git", { upward = true, path = start_dir })[1]
    local root = git_dir and vim.fs.dirname(git_dir) or "."

    -- Create exactly one new empty split on the RIGHT
    vim.cmd("botright vnew")
    -- Optional: fix width (~25%)
    -- vim.api.nvim_win_set_width(0, math.max(20, math.floor(vim.o.columns * 0.25)))

    -- Terminal in this split, run git directly (no shell init, no pager)
    vim.fn.termopen({ "git", "-c", "core.pager=cat", "-C", root, "lg" })

    -- Tidy UI
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    -- Stay in NORMAL mode so :q closes it immediately
end, { desc = "Right vsplit terminal running git lg (single split)" })


vim.keymap.set('n', '<leader>os', ':ObsidianSearch ')
