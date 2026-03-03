return {
	"neovim/nvim-lspconfig",
	dependencies = { "saghen/blink.cmp" },

	-- example using `opts` for defining servers
	opts = {
		servers = {
			-- 	lua_ls = {},
			-- 	ts_ls = {},
			biome = {
				root_dir = function(fname)
					return vim.fs.root(fname, { "biome.json", "biome.jsonc" })
				end,
				on_attach = function(client, bufnr)
					-- Auto-fix and format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						group = vim.api.nvim_create_augroup("BiomeFixAll_" .. bufnr, { clear = true }),
						callback = function()
							vim.lsp.buf.code_action({
								context = {
									only = { "source.fixAll.biome" },
									diagnostics = {},
								},
								apply = true,
							})
						end,
					})
				end,
			},
		},
	},
	config = function() end,
}
