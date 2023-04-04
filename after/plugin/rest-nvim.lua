local rest_nvim = require("rest-nvim")

rest_nvim.setup({
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Keep the http file buffer above|left when split horizontal|vertical
    result_split_in_place = true,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Highlight request on run
    highlight = {
        enabled = true,
        timeout = 1000,
    },
    result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
          end
        },
    },
    -- Jump to request line on run
    jump_to_request = true,
    env_file = "http-client.env",
    custom_dynamic_variables = {},
    yank_dry_run = true,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = function ()
        local buff = tonumber(vim.fn.expand("<abuf>"), 10)
        vim.keymap.set("n", "<leader>rn", rest_nvim.run, { noremap = true, buffer = buff })
        vim.keymap.set("n", "<leader>rl", rest_nvim.last, { noremap = true, buffer = buff })
        vim.keymap.set("n", "<leader>rp", function () rest_nvim.run(true) end, { noremap = true, buffer = buff })
    end
})

