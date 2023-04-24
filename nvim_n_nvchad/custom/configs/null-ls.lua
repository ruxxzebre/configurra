local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
  formatting.prettier,
  formatting.stylua,
  lint.eslint_d,
  lint.stylelint,
  lint.shellcheck,
  lint.markdownlint,
  lint.write_good,
  lint.vint,
  lint.pylint,
  lint.markuplint,
}

null_ls.setup {
  debug = true,
  sources = sources,
}
