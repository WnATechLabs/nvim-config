-- use this table to disable/enable copilot file types
-- vim.g.copilot_filetypes = {
--   lua = true,
--   python = true,
-- }

-- since most are enable by default you can turn them off
-- using this table and only enable for a few filetypes
-- vim.g.copilot_filetypes = { ["*"] = false, lua = true, python = true }

vim.keymap.set('i', '<C-]>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-\\>', '<Plug>(copilot-suggest)')
vim.keymap.set('i', '<M-]>', '<Plug>(copilot-dismiss)')

