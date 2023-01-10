-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

require('packer').init {
 git = { clone_timeout = 60 * 60 * 60 }
}

return require('packer').startup(function(use)
	-- Packer can manage itself
	use('wbthomason/packer.nvim')

    -- Themes
	use({
		'rose-pine/neovim',
		as = 'rose-pine'
	})

	use({
		"EdenEast/nightfox.nvim",
		config = function()
			vim.cmd("colorscheme nightfox")
		end
	})
    -- end themes

    -- General plugins to make my life easier
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

	use('nvim-lua/plenary.nvim')

	use('ThePrimeagen/harpoon')

	use('mbbill/undotree')

	use('tpope/vim-fugitive')

    use({
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup {}
        end,
    })
    -- end general plugins

    -- LSP
	use {
		'VonHeikemen/lsp-zero.nvim',
		requires = {
			-- LSP Support
			{'neovim/nvim-lspconfig'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},

			-- Autocompletion
			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			-- Snippets
			{'L3MON4D3/LuaSnip'},
			-- Snippet Collection (Optional)
			{'rafamadriz/friendly-snippets'},
		}
	}
    -- end LSP

    -- DAP
    use('mfussenegger/nvim-dap')
    use('rcarriga/nvim-dap-ui')
    use('theHamsta/nvim-dap-virtual-text')
    use('nvim-telescope/telescope-dap.nvim')
    -- -- js
    use {
        "microsoft/vscode-js-debug",
        opt = true,
        run = "npm install --legacy-peer-deps && npm run compile"
    }
    use { "mxsdev/nvim-dap-vscode-js", requires = {"mfussenegger/nvim-dap"} }
    -- end DAP

	-- Dart/Flutter
	-- use('dart-lang/dart-vim-plugin')
	-- use('thosakwe/vim-flutter')

  end)
