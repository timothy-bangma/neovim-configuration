vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.incsearch = true
vim.opt.signcolumn = "yes:1"
vim.g.maplocalleader = ';'

--- downloads plugins and adds them to the runtime path.
local function packadd(repo_list)
	for _, repo in pairs(repo_list) do
		local repo_name = string.gmatch(repo, "[^/]+/[^/]+$")()
		local outdir = vim.fn.stdpath('data') .. "/" .. repo_name

		if not vim.uv.fs_stat(outdir) then
			print('Downloading [' .. repo_name .. '] to [' .. outdir .. ']')
			vim.fn.system({ 'git', 'clone', repo, outdir })
		end
		vim.opt.rtp:prepend(outdir)
	end
end

packadd({
	-- fzf and its various integrations
	'https://github.com/junegunn/fzf',
	'https://github.com/junegunn/fzf.vim',
	-- lsp configurations, for analysis on save.
	'https://github.com/neovim/nvim-lspconfig',
	-- treesitter grammers, for syntax highlighting
	'https://github.com/nvim-treesitter/nvim-treesitter',
	-- scheme, lisp, lua REPL.
	'https://github.com/olical/conjure',
	-- configuration to make chibi-scheme the default.
	'https://git.pub.solar/xhcf/conjure-chibi-scheme',
	-- personal treesitter extension to the quiet.vim theme.
	'https://git.pub.solar/xhcf/quiet-extended',
})

require('lspconfig').lua_ls.setup {}
require('lspconfig').zls.setup {}
require('lspconfig').clangd.setup {}

vim.diagnostic.config { virtual_text = false, underline = false }
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', ';;', ':lua vim.lsp.buf.format()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', ':lua vim.lsp.buf.definition()<CR>', opts)

require('nvim-treesitter.configs').setup {
	highlight = { enable = true, additional_vim_regex_highlighting = false }
}
require('conjure-chibi').setup {}

vim.cmd.colorscheme("quiet-extended")
