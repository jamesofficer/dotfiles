return {
	"yorickpeterse/nvim-jump",
	version = "*",
	keys = {
		{ "s", function() require("jump").start() end, mode = { "n", "x", "o" }, desc = "Nvim Jump" },
	},
}
