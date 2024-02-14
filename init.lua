-- install paq package manager if its missing
local paq_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(paq_path)) ~= 0 then
    vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_path }
    vim.cmd.packadd('paq-nvim')
end

require('paq') {
  'savq/paq-nvim', 
  'nvim-treesitter/nvim-treesitter',
  'nyoom-engineering/oxocarbon.nvim',
}.install()

require ('nvim-treesitter.configs').setup {
  ensure_installed = { 'javascript', 'typescript', 'lua', 'rust', 'fennel' },
  highlight = { enable = true },
}

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.cmd("colorscheme oxocarbon")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) 
