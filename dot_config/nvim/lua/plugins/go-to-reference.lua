return {
	dir = vim.fn.stdpath("config") .. "/lua/projects",
	name = "goto-file-references",
	config = function()
		require("projects.goto-file-references").setup()
	end,
}
