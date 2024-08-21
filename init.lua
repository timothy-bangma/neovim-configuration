local leader_key = ';'
vim.g.mapleader = leader_key
vim.g.maplocalleader = leader_key

local tab_width = 2
vim.opt.softtabstop = tab_width
vim.opt.shiftwidth = tab_width
vim.opt.tabstop = tab_width

vim.opt.incsearch = true
vim.opt.signcolumn = "yes:1"

vim.opt.mouse = ""

-- conjure scheme client configuration
vim.g["conjure#mapping#doc_word"] = false
local scheme_client = 'conjure#client#scheme#stdio#'
vim.g[scheme_client .. 'command'] = "chibi-scheme"
vim.g[scheme_client .. 'value_prefix_pattern'] = ""
vim.g[scheme_client .. 'prompt_pattern'] = "> "

-- assumes github. makes things simpler
local function packadd(repo_list)
	for _, repo_name in pairs(repo_list) do
		local repo = 'https://github.com/' .. repo_name
		local outdir = vim.fn.stdpath('data') .. "/" .. repo_name

		if not vim.uv.fs_stat(outdir) then
			print('Downloading [' .. repo_name .. '] to [' .. outdir .. ']')
			vim.fn.system({ 'git', 'clone', repo, outdir })
		end
		vim.opt.rtp:prepend(outdir)
	end
end

-- plugins
packadd({
	'junegunn/fzf',
	'junegunn/fzf.vim',
	'neovim/nvim-lspconfig',
	'nvim-treesitter/nvim-treesitter',
	'olical/conjure',
	'xhcf/quiet-extended',
})

vim.cmd.colorscheme("quiet-extended")

-- lsp configuration
require('lspconfig').lua_ls.setup {}
require('lspconfig').zls.setup {}

vim.diagnostic.config { virtual_text = false, underline = false }
vim.api.nvim_set_keymap('n', '<leader><leader>', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })

-- treesitter config
require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}
