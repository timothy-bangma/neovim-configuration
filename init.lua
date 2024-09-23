vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.incsearch = true
vim.opt.signcolumn = "yes:1"
vim.g.maplocalleader = ';'

vim.opt.statusline="%f%m%=%y 0x%B %l:%c %p%%"

--- downloads plugins and adds them to the runtime path.
local function packadd(repo_list)
	for _, repo in pairs(repo_list) do
		local outdir = vim.fn.stdpath('data') .. "/" .. repo

		if not vim.uv.fs_stat(outdir) then
			print('Downloading [' .. repo .. '] ...')
			vim.fn.system({ 'git', 'clone', "https://github.com/" .. repo, outdir })
		end
		vim.opt.rtp:prepend(outdir)
	end
end

packadd({
	'neovim/nvim-lspconfig',
	'nvim-treesitter/nvim-treesitter',
	'timothy-bangma/quiet-extended',
})

require('lspconfig').lua_ls.setup {}
require('lspconfig').clangd.setup {}
require('lspconfig').zls.setup {}

vim.diagnostic.config { virtual_text = false, underline = false }
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', ';;', ':lua vim.lsp.buf.format()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', ':lua vim.lsp.buf.definition()<CR>', opts)

require('nvim-treesitter.configs').setup {
	highlight = { enable = true, additional_vim_regex_highlighting = false }
}

vim.cmd.colorscheme("quiet-extended")
