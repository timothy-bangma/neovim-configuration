local tab_width = 2
local leader_key = ';'
local scheme_client = 'conjure#client#scheme#stdio#'

vim.g.mapleader = leader_key
vim.g.maplocalleader = leader_key

vim.opt.softtabstop = tab_width
vim.opt.shiftwidth = tab_width
vim.opt.tabstop = tab_width

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes:1"

vim.opt.mouse = ""

-- keymapping
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<localleader>ff', ':lua vim.lsp.buf.format()<CR>', opts)
vim.api.nvim_set_keymap('n', '<localleader>ii', ':lua vim.diagnostic.open_float(nil, {focus=false})<CR>', opts)

-- conjure scheme client configuration
vim.g[scheme_client .. 'command'] = "chibi-scheme"
vim.g[scheme_client .. 'value_prefix_pattern'] = ""
vim.g[scheme_client .. 'prompt_pattern'] = "> "

-- colorscheme configuring based on treesitter
vim.cmd.colorscheme("quiet")

local function hi(groups, format)
	for _, group in pairs(groups) do vim.api.nvim_set_hl(0, group, format) end
end

hi({ 'NormalFloat' }, { bg = 'None' })
hi({ 'Comment', 'Delimiter', 'Operator' }, { fg = '#3c3c3c' })
hi({ 'Keyword', 'Conditional' }, { fg = '#6d6d6d', bold = true })
hi({ 'Boolean', 'Constant', 'String' }, { fg = '#a2a2a2' })

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
})

-- lsp configuration
require('lspconfig').lua_ls.setup {}
vim.diagnostic.config { virtual_text = false, underline = false }
