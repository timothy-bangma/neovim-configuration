--- downloads plugins from github, and adds them to the runtime path.
local function packadd(repo_list)
	for _, repo in pairs(repo_list) do
		local repo_name = string.gmatch(repo, "[^/]+/[^/]+$")()
		local outdir = vim.fn.stdpath('data') .. "/" .. repo_name

		if not vim.uv.fs_stat(outdir) then
			print('Downloading [' .. repo_name .. '] to [' .. outdir .. '] from [' .. repo .. ']')
			vim.fn.system({ 'git', 'clone', repo, outdir })
		end
		vim.opt.rtp:prepend(outdir)
	end
end

--- activates lsp client configs
local function lsp(lsp_list)
	local cfg = require('lspconfig')
	for _, lsp_name in pairs(lsp_list) do cfg[lsp_name].setup {} end
end

--- shortcut for nnoremap silent
local function nmap(keys, fn)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap('n', keys, ':lua ' .. fn .. '<CR>', opts)
end

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

packadd({
	'https://github.com/junegunn/fzf',
	'https://github.com/junegunn/fzf.vim',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/olical/conjure',
	'https://git.pub.solar/xhcf/quiet-extended',
})

vim.cmd.colorscheme("quiet-extended")

local scheme_client = 'conjure#client#scheme#stdio#'
vim.g["conjure#mapping#doc_word"] = false
vim.g[scheme_client .. 'command'] = "chibi-scheme"
vim.g[scheme_client .. 'value_prefix_pattern'] = false
vim.g[scheme_client .. 'prompt_pattern'] = "> "

lsp({ 'lua_ls', 'zls', 'gopls' })

vim.diagnostic.config { virtual_text = false, underline = false }

nmap('<leader><leader>', 'vim.lsp.buf.format()')
nmap('gD', 'vim.lsp.buf.definition()')

require('nvim-treesitter.configs').setup {
	highlight = { enable = true, additional_vim_regex_highlighting = false },
}
