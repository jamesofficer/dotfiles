local M = {}

function M.organize_imports(bufnr)
	bufnr = bufnr or 0
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local biome_available = false

	for _, client in ipairs(clients) do
		if client.name == "biome" then
			biome_available = true
			break
		end
	end

	local action = biome_available and "source.organizeImports.biome" or "source.organizeImports.ts"

	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { action },
			diagnostics = {},
		},
	})
end

return M

