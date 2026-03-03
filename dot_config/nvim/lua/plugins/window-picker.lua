return {
	"s1n7ax/nvim-window-picker",
	name = "window-picker",
	event = "VeryLazy",
	version = "2.*",
	config = function()
		require("window-picker").setup({
			selection_chars = "shtareni",
			hint = "floating-big-letter",
			picker_config = {
				floating_big_letter = {
					font = "ansi-shadow",
				},
			},
		})

		vim.keymap.set("n", "<leader>i", function()
			local picked_window_id = require("window-picker").pick_window()
			-- You can add logic here if you want to do something with the window id
			if picked_window_id then
				vim.api.nvim_set_current_win(picked_window_id)
			end
		end, {
			desc = "Pick Window",
		})
	end,
}
