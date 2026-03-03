return {
	"williamboman/mason-lspconfig.nvim",
	opts = function()
		return {
			ensure_installed = { "biome" },
			handlers = {
				function(server_name)
					local nvim_lspconfig_plugin = require("lazy.core.config").plugins["nvim-lspconfig"]
					local server_opts = {}
					if nvim_lspconfig_plugin and nvim_lspconfig_plugin.opts then
						server_opts = nvim_lspconfig_plugin.opts.servers[server_name] or {}
					end
					server_opts.capabilities = require("blink.cmp").get_lsp_capabilities(server_opts.capabilities)
					vim.lsp.config(server_name, server_opts)
					vim.lsp.enable(server_name)
				end,
			},
		}
	end,
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
}
