return {
	"echasnovski/mini.surround",
	version = "*",
	config = function()
		require("mini.surround").setup({
			-- How far to search for surroundings
			n_lines = 200,

			-- add more mappings here
			mappings = {
				add = "za", -- Add surrounding in Normal and Visual modes
				delete = "zd", -- Delete surrounding
				find = "zf", -- Find surrounding (to the right)
				find_left = "zF", -- Find surrounding (to the left)
				highlight = "zh", -- Highlight surrounding
				replace = "zr", -- Replace surrounding
				update_n_lines = "zn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			custom_surroundings = {
				T = {
					input = { "<(%w+)[^<>]->.-</%1>", "^<()%w+().*</()%w+()>$" },
					output = function()
						local tag_name = MiniSurround.user_input("Tag name")
						if tag_name == nil then
							return nil
						end
						return { left = tag_name, right = tag_name }
					end,
				},
			},
		})
	end,
}
