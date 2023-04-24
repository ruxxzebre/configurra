local function show_diagnostics_in_split()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)

  if #diagnostics == 0 then
    print("No diagnostics found")
    return
  end

  local diagnostic_buf = vim.api.nvim_create_buf(false, true)
  local lines = {}

  for _, diagnostic in ipairs(diagnostics) do
    local message = diagnostic.message:gsub("\r", ""):gsub("\n", " ")
    table.insert(lines, message)
  end

  vim.api.nvim_buf_set_lines(diagnostic_buf, 0, -1, false, lines)

  -- Open a new split window at the bottom
  vim.cmd("botright new")
  local diagnostic_win = vim.api.nvim_get_current_win()

  -- Set the new split window to use the diagnostic buffer
  vim.api.nvim_win_set_buf(diagnostic_win, diagnostic_buf)

  -- Set options for the diagnostic window
  vim.api.nvim_win_set_option(diagnostic_win, "wrap", true)
  -- vim.api.nvim_win_set_option(diagnostic_win, "textwidth", math.floor(vim.o.columns * 0.9))
  -- vim.api.nvim_win_set_option(diagnostic_win, "bufhidden", "wipe")
  -- vim.api.nvim_win_set_option(diagnostic_win, "buftype", "nofile")
  -- vim.api.nvim_win_set_option(diagnostic_win, "modifiable", false)
  -- vim.api.nvim_buf_set_option(diagnostic_buf, "filetype", "diagnostic")
end

local function _show_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)

  if #diagnostics == 0 then
    return
  end

  local floating_buf = vim.api.nvim_create_buf(false, true)
  local lines = {}

  for _, diagnostic in ipairs(diagnostics) do
    local message = diagnostic.message:gsub("\r", ""):gsub("\n", " ")
    table.insert(lines, message)
  end

  vim.api.nvim_buf_set_lines(floating_buf, 0, -1, false, lines)

  local opts = {
    relative = "cursor",
    style = "minimal",
    width = math.min(math.floor(vim.o.columns * 0.9), 80),
    height = math.min(#lines, math.floor(vim.o.lines * 0.8)),
    row = 0,
    col = 1,
  }

  local popup_win = vim.api.nvim_open_win(floating_buf, false, opts)
  vim.api.nvim_win_set_option(popup_win, "wrap", true)
  vim.api.nvim_win_set_option(popup_win, "textWidth", opts.width)
end

local M = {}

-- In order to disable a default keymap, use
M.disabled = {
-- n = {
      -- ["<leader>h"] = "",
      -- ["<C-a>"] = ""
  -- }
}


-- Your custom mappings
M.abc = {
  n = {
    ["<space>i"] = {show_diagnostics_in_split, "Show diagnostics in split"},
    ["[d"] = {vim.diagnostic.goto_prev, "Go to previous diagnostic"},
    ["]d"] = {vim.diagnostic.goto_next, "Go to next diagnostic"},
    ["<space>q"] = {vim.diagnostic.setloclist, "Set diagnostic location list"},
  },

  i = {
    -- Add insert mode mappings here if needed
  }
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    -- add object to M.abc.n
    M.abc.n["<space>ca"] = {vim.lsp.buf.code_action, "Code action", opts};
    M.abc.n["gD"] = {vim.lsp.buf.declaration, "Go to declaration", opts};
    M.abc.n["gd"] = {vim.lsp.buf.definition, "Go to definition", opts};
    M.abc.n["<space>K"] = {vim.lsp.buf.hover, "Show hover", opts};
    M.abc.n["gm"] = {vim.lsp.buf.implementation, "Go to implementation", opts};
    M.abc.n["<C-k>"] = {vim.lsp.buf.signature_help, "Show signature help", opts};
    M.abc.n["<space>wa"] = {vim.lsp.buf.add_workspace_folder, "Add workspace folder", opts};
    M.abc.n["<space>wr"] = {vim.lsp.buf.remove_workspace_folder, "Remove workspace folder", opts};
    M.abc.n["<space>wl"] = {function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspace folders", opts};
    M.abc.n["<space>D"] = {vim.lsp.buf.type_definition, "Go to type definition", opts};
    M.abc.n["<space>rn"] = {vim.lsp.buf.rename, "Rename symbol", opts};
    M.abc.n["<space>ca"] = {vim.lsp.buf.code_action, "Code action", opts};
    M.abc.n["gr"] = {vim.lsp.buf.references, "Find references", opts};
    M.abc.n["<space>fl"] = {function()
      vim.lsp.buf.format { async = true }
    end, "Format buffer", opts};
    -- Additional key bindings
    M.abc.n["<space>qs"] = {vim.lsp.diagnostic.set_loclist, "Set diagnostic location list", opts};
    M.abc.n["<space>[d"] = {vim.lsp.diagnostic.goto_prev, "Go to previous diagnostic", opts};
    M.abc.n["<space>]d"] = {vim.lsp.diagnostic.goto_next, "Go to next diagnostic", opts};
    M.abc.n["<space>qd"] = {function()
      vim.lsp.diagnostic.show_line_diagnostics { border = "single" }
    end, "Show line diagnostics", opts};
  end,
})

return M
