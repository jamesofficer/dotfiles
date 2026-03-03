return {
	dir = vim.fn.stdpath("config") .. "/lua/projects",
	name = "quicklog",
	config = function()
		require("projects.quicklog").setup()
	end,
}
