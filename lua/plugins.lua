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

function M.mason(install_list)
  local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- to learn how to use mason.nvim
  -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md
  require("mason").setup({})
  require("mason-lspconfig").setup({
    ensure_installed = install_list,
    handlers = {
      function(server_name)
        require("lspconfig")[server_name].setup({})
      end,
      lua_ls = function()
        require("lspconfig").lua_ls.setup({
          capabilities = lsp_capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { library = { vim.env.VIMRUNTIME } },
            },
          },
        })
      end,
    },
  })
end

function M.conform(formatters)
  require("conform").setup({
    formatters_by_ft = formatters,
    format_on_save = {
      -- I recommend these options. See :help conform.format for details.
      lsp_format = "fallback",
      timeout_ms = 500,
    },
  })
end

function M.treesitter(parsers)
  table.insert(parsers, "vim")
  table.insert(parsers, "vimdoc")
  table.insert(parsers, "query")
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = parsers,

    highlight = { enable = true },
  })
end

function M.telescope_keymap()
  local builtin = require('telescope.builtin')

  local zig_cfg = {
    cwd = "/opt/zig/lib/std",
    layout_strategy = 'vertical',
    layout_config = { width = 0.99, height = 0.99 }
  }

  vim.keymap.set('n', '<leader>zf', function() builtin.find_files(zig_cfg) end, {})
  vim.keymap.set('n', '<leader>zg', function() builtin.live_grep(zig_cfg) end, {})

  vim.keymap.set('n', '<leader>ts', builtin.treesitter, {})
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
end

return function(plugins)
  -- required for lsp stuff...
  table.insert(plugins, { "williamboman/mason-lspconfig.nvim" })
  table.insert(plugins, { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" })
  table.insert(plugins, { "neovim/nvim-lspconfig" })
  table.insert(plugins, { "hrsh7th/cmp-nvim-lsp" })
  table.insert(plugins, { "hrsh7th/nvim-cmp" })
  table.insert(plugins, { "L3MON4D3/LuaSnip" })
  require("lazy").setup(plugins)

  local lsp_zero = require("lsp-zero")
  lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

  return M
end
