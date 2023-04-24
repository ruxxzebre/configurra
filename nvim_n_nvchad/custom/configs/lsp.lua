local lspconfig = require("lspconfig")

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local servers = { "cssls" }
  --"clangd"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.html.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "handlebars", "hbs", "html-eex" },
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  -- settings = {
  --   ["rust-analyzer"] = {
  --     assist = {
  --       importGranularity = "module",
  --       importPrefix = "by_self",
  --     },
  --     cargo = {
  --       loadOutDirsFromCheck = true,
  --     },
  --     procMacro = {
  --       enable = true,
  --     },
  --   },
  -- },
}

lspconfig.gopls.setup {}

lspconfig.elixirls.setup {}

lspconfig.tsserver.setup {}

lspconfig.eslint.setup({
  on_attach = function (_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll"
    })
  end,
})

