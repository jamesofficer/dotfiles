return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = false },
		bufdelete = { enabled = true },
		dashboard = { enabled = false },
		dim = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		lazygit = { enabled = true },
		gitbrowse = { enabled = true },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		rename = { enabled = true },
		scroll = {
			enabled = false,
			animate = {
				duration = { step = 10, total = 150 },
				easing = "linear",
			},
		},
		statuscolumn = { enabled = false },
		terminal = { enabled = true },
		words = { enabled = true },
		zen = { enabled = false },
	},
	keys = {
		--------------
		-- Scroll
		--------------
		{
			"<leader>us",
			function()
				if Snacks.scroll.enabled then
					Snacks.scroll.disable()
				else
					Snacks.scroll.enable()
				end
			end,
			desc = "Toggle Scroll",
		},
		--------------
		-- Terminal
		--------------
		{
			"<leader>M",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
		--------------
		-- Bufdelete
		--------------
		{
			"<leader>bD",
			function()
				Snacks.bufdelete()
			end,
			desc = "Bufdelete",
		},
		--------------
		-- Zen
		--------------
		-- {
		-- 	"<leader>uz",
		-- 	function()
		-- 		Snacks.zen()
		-- 	end,
		-- 	desc = "Zen",
		-- },
		--------------
		-- Words
		--------------
		{
			"<leader>uw",
			function()
				if Snacks.words.is_enabled() then
					Snacks.words.disable()
				else
					Snacks.words.enable()
				end
			end,
			desc = "Toggle Words",
		},
		--------------
		-- Dim
		--------------
		{
			"<leader>ud",
			function()
				if Snacks.dim.enabled then
					Snacks.dim.disable()
				else
					Snacks.dim.enable()
				end
			end,
			desc = "Toggle Dim",
		},
		--------------
		-- LazyGit
		--------------
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
		--------------
		-- GitBrowse
		--------------
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "GitBrowse",
		},
	},
}
