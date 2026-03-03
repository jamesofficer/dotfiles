return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		require("which-key").setup()
		require("which-key").add({
			{ "<leader>a", group = "[A]i Assitant" },
			{ "<leader>b", group = "[B]uffers" },
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]iagnostics" },
			{ "<leader>i", group = "P[i]ck Window" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>M", group = "Ter[M]inal" },
			{ "<leader>t", group = "Spli[t]s" },
			{ "<leader>g", group = "[G]it", mode = { "n", "v" } },
			{ "<leader>u", group = "[U]ser Interface" },
			{ "<leader>f", group = "[F]lutter" },
			{ "<leader>u", group = "[U]ser Interface" },
			{ "<leader>p", group = "[P]inned Files" },
			{ "<leader>b", group = "[B]uffers" },
			{ "<leader>l", group = "[L]SP" },
		})
	end,
}
