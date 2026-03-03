return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({
					async = true,
					lsp_fallback = false, -- prefer explicit formatters
				})
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = function()
		local util = require("conform.util")

		local biome_filetypes = {
			javascript = true,
			javascriptreact = true,
			typescript = true,
			typescriptreact = true,
			json = true,
			jsonc = true,
			css = true,
		}

		return {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local ft = vim.bo[bufnr].filetype
				local bufname = vim.api.nvim_buf_get_name(bufnr)

				if bufname:match("/node_modules/") then
					return
				end

				-- Avoid noisy failures on save if no import code action is available
				pcall(function()
					require("utils").organize_imports(bufnr)
				end)

				return {
					timeout_ms = 1000,
					lsp_fallback = not biome_filetypes[ft], -- never fallback for Biome-managed files
				}
			end,
			formatters = {
				biome = {
					-- Workaround for Biome stdin empty-output behavior
					stdin = false,
					args = { "format", "--write", "$FILENAME" },
					cwd = util.root_file({
						"biome.json",
						"biome.jsonc",
						"pnpm-workspace.yaml",
						".git",
					}),
					require_cwd = true,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "biome" },
				javascriptreact = { "biome" },
				typescript = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				jsonc = { "biome" },
				css = { "biome" },
			},
		}
	end,
}
