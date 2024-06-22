vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

vim.cmd([[
  let g:conjure#filetype#r7rs = 'conjure.client.scheme.stdio'
  let g:conjure#client#scheme#stdio#command = "chibi-scheme"
  let g:conjure#client#scheme#stdio#prompt_pattern = "> "
  let g:conjure#client#scheme#stdio#value_prefix_pattern = v:false
]])

local plugins = require("plugins")({
	{ "williamboman/mason.nvim" }, -- neovim package manager
	{ "stevearc/conform.nvim", opts = {} }, -- formatter
	{ "nvim-treesitter/nvim-treesitter" }, -- syntax highlighter
	{ "Olical/conjure" }, -- LISP / Scheme REPL tools.
	{ "m15a/vim-r7rs-syntax" }, -- better r7rs scheme syntax.
	{ "kepano/flexoki-neovim", name = "flexoki" },
})
plugins.mason({ "lua_ls", "fennel_language_server" })
plugins.conform({ lua = { "stylua" }, ["_"] = { "trim_whitespace" } })
plugins.treesitter({ "c", "lua" })

-- Tab
vim.opt.tabstop = 2 -- number of visual spaces per TAB
vim.opt.softtabstop = 2 -- number of spacesin tab when editing
vim.opt.shiftwidth = 2 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of python

-- UI config
vim.opt.number = true -- enables line numbers
vim.opt.signcolumn = "number" -- add numbers to each line on the left side
vim.opt.cursorline = true -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true -- but make it case sensitive if an uppercase is entered

vim.api.nvim_set_keymap("n", "<localleader>f", ":Explore<CR>", { silent = true })

-- colorscheme
vim.cmd.colorscheme("flexoki-dark")
