return {
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	{
		"pappasam/papercolor-theme-slim",
		priority = 1000,
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		-- init = function()
		-- 	vim.cmd.colorscheme("tokyonight-moon")
		-- 	vim.cmd.hi("Comment gui=none")
		-- end,
	},
	{
		"sainnhe/gruvbox-material",
		lazy = true,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			-- vim.g.gruvbox_material_enable_italic = true
			-- vim.cmd.colorscheme("gruvbox-material")
		end,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").setup({
				-- optional configuration here
			})
			-- require("bamboo").load()
		end,
	},
	{
		"sainnhe/sonokai",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.sonokai_enable_italic = true
			-- vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.vscode_style = "dark"
			-- vim.cmd.colorscheme("vscode")
		end,
	},
	{
		"bluz71/vim-nightfly-colors",
		name = "nightfly",
		lazy = false,
		priority = 1000,
	},
	{
		"Kaikacy/Lemons.nvim",
		version = "*", -- for stable release
		lazy = false,
		priority = 1000,
	},
	{
		"zenbones-theme/zenbones.nvim",
		-- Optionally install Lush. Allows for more configuration or extending the colorscheme
		-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
		-- In Vim, compat mode is turned on as Lush only works in Neovim.
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		-- you can set set configuration options here
		-- config = function()
		--     vim.g.zenbones_darken_comments = 45
		--     vim.cmd.colorscheme('zenbones')
		-- end
	},
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.everforest_enable_italic = true
			vim.cmd.colorscheme("everforest")
		end,
	},
	{ "savq/melange-nvim" },
	{ "rebelot/kanagawa.nvim" },
	{
		"wtfox/jellybeans.nvim",
		lazy = false,
		priority = 1000,
		opts = {}, -- Optional
	},
	{
		"uloco/bluloco.nvim",
		lazy = false,
		priority = 1000,
		dependencies = { "rktjmp/lush.nvim" },
		config = function()
			-- your optional config goes here, see below.
		end,
	},
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
	{ "EdenEast/nightfox.nvim" },
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{
		"marko-cerovac/material.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"oskarnurm/koda.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
	},
	{
		"kaiuri/nvim-juliana",
		lazy = false,
		opts = { --[=[ configuration --]=]
		},
		config = true,
	},
	{
		"loctvl842/monokai-pro.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai-pro").setup()
			vim.cmd.colorscheme("monokai-pro")
		end,
	},
}
