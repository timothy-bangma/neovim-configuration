-- ON FIRST INSTALL:
-- 1. copy this file into:
--    - ~/AppData/Local/nvim/init.lua    (for Windows)
--    - ~/.config/nvim/init.lua          (for everything else)

-- 2. run `nvim` it will throw an error, hit enter, let Paq download plugins.

-- 3. Quit out, and run `nvim` again. Treesitter will start downloading its parsers
--    - if you don't have a c compiler on your path (usually on windows) download zig, its the simplest.

-- 4. Happy coding... :-)

-- install paq package manager if its missing
local paq_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(paq_path)) ~= 0 then
    vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', paq_path }
    vim.cmd.packadd('paq-nvim')
end

require('paq') {
  'savq/paq-nvim', -- this plugin manager (self updating)
  'nvim-treesitter/nvim-treesitter', -- treesitter for better syntx highlighting
  'nyoom-engineering/oxocarbon.nvim', -- simple theme based on treesitter data
}.install()

require ('nvim-treesitter.configs').setup {
  ensure_installed = { 'javascript', 'typescript', 'lua', 'rust', 'fennel', 'zig' },
  highlight = { enable = true },
}

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.cmd("colorscheme oxocarbon")
-- remove background in terminal window.
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) 
