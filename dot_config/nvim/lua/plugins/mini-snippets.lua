return {
	"echasnovski/mini.snippets",
	version = "*",
	config = function()
		local gen_loader = require("mini.snippets").gen_loader

		require("mini.snippets").setup({
			clear_extmarks_on_leave = true,
			mappings = {
				expand = "<C-e>",
				-- Interact with default `expand.insert` session.
				-- Created for the duration of active session(s)
				jump_next = "<C-l>",
				jump_prev = "<C-h>",
				stop = "<C-c>",
			},
			snippets = {
				-- Load custom file with global snippets first (adjust for Windows)
				gen_loader.from_file("~/.config/nvim/snippets/global.json"),

				-- Load snippets based on current language by reading files from
				-- "snippets/" subdirectories from 'runtimepath' directories.
				gen_loader.from_lang({
					lang_patterns = {
						tsx = { "typescriptreact/*" }, -- Use typescriptreact snippets for tsx
					},
				}),
			},
		})
	end,
}
