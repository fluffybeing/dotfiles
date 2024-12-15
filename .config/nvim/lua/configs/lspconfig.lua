-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")
local nvlsp = require("nvchad.configs.lspconfig")

-- list of all servers configured.
lspconfig.servers = {
  "lua_ls",
  "pyright",
  "ts_ls",
  "tailwindcss",
  "eslint",
}

-- list of servers configured with default config.
local default_servers = {
  "lua_ls",
  "html",
  "cssls",
  "pyright",
  "ts_ls",
  "tailwindcss",
  "eslint",
  "sourcekit",
}

for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

lspconfig.sourcekit.setup({})
