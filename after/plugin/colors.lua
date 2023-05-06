require('nightfox').setup({
  options = {
    -- Compiled file's destination location
    compile_path = vim.fn.stdpath("cache") .. "/nightfox",
    compile_file_suffix = "_compiled", -- Compiled file suffix
    transparent = false,               -- Disable setting background
    terminal_colors = true,            -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false,              -- Non focused panes set to alternative background
    module_default = true,             -- Default enable value for modules
    colorblind = {
      enable = false,                  -- Enable colorblind support
      simulate_only = false,           -- Only show simulated colorblind colors and not diff shifted
      severity = {
        protan = 0,                    -- Severity [0,1] for protan (red)
        deutan = 0,                    -- Severity [0,1] for deutan (green)
        tritan = 0,                    -- Severity [0,1] for tritan (blue)
      },
    },
    styles = {
               -- Style to be applied to different syntax groups
      conditionals = "NONE",
      constants = "NONE",
      functions = "NONE",
      numbers = "NONE",
      operators = "NONE",
      strings = "NONE",
      variables = "NONE",
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    },
    inverse = {
                -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
    modules = { -- List of various plugins and additional options
      -- ...
    },
  },
  palettes = {},
  specs = {},
  groups = {},
})

function ColorMe(color, solidBg)
  color = color or "nightfox"
  solidBg = solidBg or false
  vim.cmd.colorscheme(color)

  if (not solidBg) then
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  end
end

ColorMe()

vim.keymap.set('n', '<leader><leader>b', ':lua ColorMe(nil, true)<CR>')
vim.keymap.set('n', '<leader><leader>B', ':lua ColorMe(nil, false)<CR>')
