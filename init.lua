require('options')
require('colours')

require('lazy-bootstrap')
require('lazy').setup({
    {'nvim-treesitter/nvim-treesitter'},
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},
    { "williamboman/mason.nvim" },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'junegunn/fzf' },
    { 'junegunn/fzf.vim' }
})
require('lsp-config')
require('treesitter-config')
