return {
	"echasnovski/mini.files",
	lazy = false,
	version = "*",
	config = function()
		local minifiles = require("mini.files")

		vim.keymap.set("n", "<leader>e", function()
			local currentbuffer = vim.api.nvim_buf_get_name(0)
			minifiles.open(currentbuffer)
		end, { desc = "Fil[e] Browser" })

		minifiles.setup({
			mappings = {
				close = "q",
				go_in = "<Right>",
				go_in_plus = "L",
				go_out = "<Left>",
				go_out_plus = "H",
				reset = "<BS>",
				reveal_cwd = "@",
				show_help = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},

			windows = {
				max_number = math.huge,
				preview = false,
				width_focus = 50,
				width_nofocus = 15,
				-- width_preview = 100,
			},

			options = {
				use_as_default_explorer = true,
			},

			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesActionRename",
				callback = function(event)
					Snacks.rename.on_rename_file(event.data.from, event.data.to)
				end,
			}),
		})
	end,
}
