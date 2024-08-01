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

vim.opt.mouse = ""

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
  { "nvim-treesitter/nvim-treesitter" }, -- syntax highlighting
  {
    'VonHeikemen/lsp-zero.nvim',         -- less config lsp
    branch = 'v3.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' }, -- neovim lsp configurations
    }

  },
  {
    'hrsh7th/nvim-cmp',           -- completion plugin
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' }, -- lsp completion source
      { 'hrsh7th/cmp-buffer' },   -- buffer source
      { 'hrsh7th/cmp-path' },     -- path source
      { 'hrsh7th/cmp-cmdline' },  -- cmdline source
    }
  },
  {
    "Olical/conjure",
    ft = { "scm", "fnl", "lua" },                 -- LISP / Scheme REPL tools.
    dependencies = {
      { "m15a/vim-r7rs-syntax", ft = { "scm" } }, -- better r7rs scheme syntax.
    }
  },
  {
    'nvim-telescope/telescope.nvim', -- file finder / search
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
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

-- ---------------- --
-- TELESCOPE CONFIG --
-- ---------------- --
require('telescope').setup {
  defaults = {
    layout_strategy = "vertical",
    layout_config = {
      mirror = true,
      prompt_position = "bottom",
    },
  }
}

local builtin = require('telescope.builtin')
local themes = require('telescope.themes')

vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>lua TelescopeFindFiles()<cr>", {})
function TelescopeFindFiles()
  builtin.find_files(themes.get_ivy({ previewer = false }))
end

vim.api.nvim_set_keymap("n", "<leader>zg", "<cmd>lua ZigSourceSearch()<cr>", {})
function ZigSourceSearch()
  builtin.live_grep({
    search_dirs = {
      '/opt/zig/lib/std',
      '/opt/tigerbeetle/src'
    }
  })
end

----------------
-- LSP CONFIG --
----------------
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup({})
lspconfig.zls.setup({})
