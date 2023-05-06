local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'lua_ls',
  'dartls',
})

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

lsp.configure('dartls', {
  force_setup = true,
  on_attach = function()
    print('attached to dartls')
  end,
})


-- lsp.configure('json-lsp', {
--     force_setup = true,
--     on_attach = function()
--         print('hello dartls')
--     end,
-- })

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<leader><tab>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = true,
  sign_icons = {
    error = '💢',
    warn = '⚠️',
    hint = '👀',
    info = '🗒️'
  }
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  if client.name == "eslint" then
    vim.cmd.LspStop('eslint')
    vim.keymap.set('n', '<leader>ef', '<cmd>silent !eslint --fix %<CR>')
    return
  end

  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gd", function()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(_, result)
      if result == nil or vim.tbl_isempty(result) then
        print("No definition found")
        return
      end
      local uri = result[1].uri
      local range = result[1].range
      vim.api.nvim_command("tabnew")
      vim.api.nvim_command("e " .. vim.uri_to_fname(uri))
      vim.api.nvim_buf_set_option(0, "buflisted", true)
      vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
    end)
  end, {})
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  -- Code folding
  vim.opt.foldcolumn = '2'
  vim.opt.foldlevel = 20
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true,
})
