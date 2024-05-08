local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  _ = client
  lsp_zero.default_keymaps({buffer = bufnr})
end)

local lua_opts = lsp_zero.nvim_lua_ls()
require('lspconfig').lua_ls.setup(lua_opts)
require('lspconfig').zls.setup({})
require('lspconfig').ols.setup({})

require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})
