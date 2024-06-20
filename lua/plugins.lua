local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

function M.lsp_zero(install_list)
  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- to learn how to use mason.nvim
  -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
  require('mason').setup({})
  require('mason-lspconfig').setup({
    ensure_installed = install_list,
    handlers = {
      function(server_name)
        require('lspconfig')[server_name].setup({})
      end,
      lua_ls = function()
      require('lspconfig').lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = {'vim'} },
            workspace = { library = { vim.env.VIMRUNTIME } }
          }
        }
      })
    end,
    },
  })
end

function M.conform(formatters)
  require("conform").setup({
    formatters_by_ft = formatters,
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  })
end

return function (plugins)
  require('lazy').setup(plugins)
  return M
end
