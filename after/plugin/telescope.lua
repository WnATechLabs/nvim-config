local builtin = require('telescope.builtin')
local opts = {
    hidden=true,
}

vim.keymap.set('n', '<leader>pf', function() builtin.find_files(opts) end, {})
vim.keymap.set('n', '<C-p>', function() builtin.git_files(opts) end, {})
vim.keymap.set('n', '<leader>ps', function() builtin.live_grep(opts) end, {})
