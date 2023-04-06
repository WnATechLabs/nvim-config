-- keymaps
vim.keymap.set("n", "<F7>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F8>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F9>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<C-F8>", ":lua require'dap'.step_out()<CR>")

vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nill, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

--config

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡️', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStoppedThreads', { text = '☠️', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🤔', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointLogMessage', { text = '📣', texthl = '', linehl = '', numhl = '' })


local dap, dapui = require("dap"), require("dapui")

dap.adapters.node2 = {
        type = "executable",
        command = "node-debug2-adapter",
        args = {}
    }
dap.set_log_level('trace')

for _, language in ipairs { "typescript", "javascript" } do
    dap.configurations[language] = {
        {
            type = 'node2',
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
        {
            type = "node2",
            request = "launch",
            name = "Launch file",
            program = "${workspaceFolder}/node_modules/.bin/nodemon",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            internalConsoleOptions = 'neverOpen',
            args = {},
        },
        {
            type = 'node2',
            request = 'launch',
            name = 'Jest tests',
            program = '${workspaceFolder}/node_modules/.bin/jest',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            args = {},
            env = {
                NODE_ENV = 'test',
            },
        },
        {
            type = "node2",
            request = "launch",
            name = "Debug Mocha Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
                "./node_modules/mocha/bin/mocha.js",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
        }
    }
end

-- Dap event listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
-- dap.listeners.after.event_terminated["dapui_config"] = function()
--     dapui.close()
-- end
-- dap.listeners.after.event_exited["dapui_config"] = function()
--     dapui.close()
-- end

require("nvim-dap-virtual-text").setup({
    show_hover = true,
    show_virtual_text = true,
    virtual_text_prefix = "🧐",
    virtual_text_position = "eol",
    virtual_text_lines = 10,
    virtual_text_source = "always",
})

-- Set up nvim-dap UI
dapui.setup({
    icons = { expanded = "▼", collapsed = "❯", current_frame = "⸰" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    -- Use this to override mappings for specific elements
    element_mappings = {
        -- Example:
        -- stacks = {
            --   open = "<CR>",
            --   expand = "o",
            -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
            {
                elements = {
                    -- Elements can be strings or table with id and size keys.
                    { id = "scopes", size = 0.25 },
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 40, -- 40 columns
                position = "left",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 0.25, -- 25% of total lines
                position = "bottom",
            },
        },
        controls = {
            -- Requires Neovim nightly (or 0.8 when released)
            enabled = true,
            -- Display controls in this element
            element = "repl",
            icons = {
                pause = "⏸️",
                play = "▶️",
                step_into = "⬇️",
                step_over = "⤵️",
                step_out = "⬆️",
                step_back = "⬅️",
                run_last = "🔁",
                terminate = "🔴",
            },
        },
        floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = "single", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
                close = { "q", "<Esc>" },
            },
        },
        windows = { indent = 1 },
        render = {
            max_type_length = nil, -- Can be integer or nil.
            max_value_lines = 100, -- Can be integer or nil.
        }
    })

