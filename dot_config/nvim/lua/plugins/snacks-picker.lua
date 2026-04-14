return {
	"folke/snacks.nvim",
	---@type snacks.Config
	opts = {
		picker = {
			enabled = true,
			layout = {
				-- hidden = { "preview" },
				layout = {
					backdrop = true,
					row = 1,
					width = 0.5,
					min_width = 80,
					height = 0.7,
					border = "none",
					box = "vertical",
					{
						win = "input",
						height = 1,
						border = true,
						title = "{title} {live} {flags}",
						title_pos = "center",
					},
					{ win = "list", border = true },
					{ win = "preview", title = "{preview}", border = true, height = 0.5 },
				},
			},
			sources = {
				pickers = { layout = { hidden = { "preview" } } },
				search_history = { layout = { hidden = { "preview" } } },
				registers = { layout = { hidden = { "preview" } } },
				select = { layout = { hidden = { "preview" } } },
			},
		},
	},
	keys = {
		{
			"<leader>sA",
			function()
				Snacks.picker()
			end,
			desc = "All Pickers",
		},
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
					filename_first = true,
					preset = "ivy",
					layout = {
						position = "bottom",
					},
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
			"<leader>sH",
			function()
				Snacks.picker.pickers()
			end,
			desc = "Picker History",
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
