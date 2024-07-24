local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  print("Bootstrapping lazy package manager")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------
-- GENERAL VIM OPTIONS --
-------------------------
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.cmd.colorscheme("retrobox")

-- conjure scheme client configuration
vim.cmd([[
  let g:conjure#filetype#r7rs = 'conjure.client.scheme.stdio'
  let g:conjure#client#scheme#stdio#command = "chibi-scheme"
  let g:conjure#client#scheme#stdio#prompt_pattern = "> "
  let g:conjure#client#scheme#stdio#value_prefix_pattern = v:false
]])

--------------------------
-- PLUGIN CONFIGURATION --
--------------------------
require("lazy").setup({
  -- lsp
  { 'VonHeikemen/lsp-zero.nvim',       branch = 'v3.x' },                              -- less config lsp
  { 'neovim/nvim-lspconfig' },                                                         -- neovim lsp configurations
  { 'hrsh7th/cmp-nvim-lsp' },                                                          -- lsp completion source
  { 'hrsh7th/nvim-cmp' },                                                              -- completion plugin
  { 'hrsh7th/cmp-buffer' },                                                            -- buffer source
  { 'hrsh7th/cmp-path' },                                                              -- path source
  { 'hrsh7th/cmp-cmdline' },                                                           -- cmdline source
  -- scheme / lisp / fennel
  { "Olical/conjure",                  ft = { "scm", "fnl" } },                        -- LISP / Scheme REPL tools.
  { "m15a/vim-r7rs-syntax",            ft = { "scm" } },                               -- better r7rs scheme syntax.
  -- treesitter parser installer
  { "nvim-treesitter/nvim-treesitter", keys = { "<leader>ts", desc = "TreeSitter" } }, -- syntax highlighter
})


-----------------------
-- LSP CONFIGURATION --
-----------------------
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- https://lsp-zero.netlify.app/v3.x/language-server-configuration.html#default-keybindings
  lsp_zero.default_keymaps({ buffer = bufnr })
  lsp_zero.buffer_autoformat()
end)

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args) vim.snippet.expand(args.body) end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})
cmp.setup.cmdline({ '/', '?' }, { sources = { { name = 'buffer' } } })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({})
lspconfig.zls.setup({})
