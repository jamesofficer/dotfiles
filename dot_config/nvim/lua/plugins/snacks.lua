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
		picker = { enabled = true },
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
		{
			"<leader>sA",
			function()
				Snacks.picker()
			end,
			desc = "All Pickers",
		},
		--------------
		-- Pickers
		--------------
		{
			"<leader>sa",
			function()
				Snacks.picker.files()
			end,
			desc = "Files (all)",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.smart({
					matcher = {
						cwd_bonus = true,
						frecency = true,
					},
					filter = {
						cwd = true,
					},
				})
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Files (in Git)",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
			desc = "Diagnostics (Buffer)",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics (All)",
		},
		{
			"<leader>sy",
			function()
				Snacks.picker.lsp_symbols({
					filter = {
						default = {
							"Class",
							-- "Constructor",
							-- "Enum",
							"Field",
							"Function",
							"Interface",
							"Method",
							-- "Module",
							-- "Namespace",
							-- "Package",
							-- "Property",
							-- "Struct",
							-- "Trait",
						},
						-- set to `true` to include all symbols
						markdown = true,
						help = true,
						-- you can specify a different filter for each filetype
					},
				})
			end,
			desc = "Lsp Symbols",
		},
		{
			"<leader>sY",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Lsp Symbols (Workspace)",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.registers()
			end,
			desc = "Registers",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.lines()
			end,
			desc = "Lines",
		},
		{
			"<leader>se",
			function()
				Snacks.picker.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo()
			end,
			desc = "Undo History",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		-- {
		-- 	"<leader>gB",
		-- 	function()
		-- 		Snacks.picker.git_branches()
		-- 	end,
		-- 	desc = "Git Branches",
		-- },
		-- {
		-- 	"<leader>gl",
		-- 	function()
		-- 		Snacks.picker.git_log()
		-- 	end,
		-- 	desc = "Git Log",
		-- },
		-- {
		-- 	"<leader>ga",
		-- 	function()
		-- 		Snacks.picker.git_stash()
		-- 	end,
		-- 	desc = "Git Stash",
		-- },
		{
			"<leader>uc",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorschemes (UI)",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
		},
	},
}
