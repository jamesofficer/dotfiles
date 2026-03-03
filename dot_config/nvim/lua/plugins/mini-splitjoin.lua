return {
	"echasnovski/mini.splitjoin",
	version = false,
	config = function()
		require("mini.splitjoin").setup({
			mappings = {
				toggle = "gS",
				split = "gj",
				join = "gJ",
			},
			detect = {
				-- Array of Lua patterns to detect region with arguments.
				brackets = { "%b()", "%b[]", "%b{}" },

				-- String Lua pattern defining argument separator
				separator = ";",

				-- Array of Lua patterns for sub-regions to exclude separators from.
				-- Enables correct detection in presence of nested brackets and quotes.
				-- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
				exclude_regions = nil,
			},
		})
	end,
}
