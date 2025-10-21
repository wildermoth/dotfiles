require("jim")
require("oil").setup()
-- Use pwsh for Neovim shell commands
vim.opt.shell = "pwsh"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
require('nvim-treesitter.install').compilers = { "zig", "gcc", "clang", "cc" }
vim.opt.clipboard = "unnamedplus"
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "markdown.mdx" },
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "" -- optional
	end,
})
