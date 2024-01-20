local conform = require("conform")
local conform_util = require("conform.util")

conform.setup({
    notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },

		-- Conform will run multiple formatters sequentially
		-- python = { "isort", "black" },

		-- Use a sub-list to run only the first available formatter
		javascript = { { "prettierd", "biome", "prettier" } },
		typescript = { { "prettierd", "biome", "prettier" } },
		typescriptreact = { { "prettierd", "biome", "prettier" } },
		json = { { "prettierd", "biome", "prettier" } },
	},
	formatters = {
		biome = {
			command = "biome",
			cwd = conform_util.root_file({ "biome.json" }),
			require_cwd = true,
		},
		prettierd = {
			command = "prettierd",
			cwd = conform_util.root_file({ "package.json" }),
			require_cwd = true,
		},
	},
	format_on_save = function(bufnr)
		-- Disable autoformat for files in a certain path ("node_modules" in this case).
		local bufname = vim.api.nvim_buf_get_name(bufnr)

		if bufname:match("/node_modules/") then
			return
		end

		return {
			timeout_ms = 1000,
			lsp_fallback = true,
		}
	end,
})

-- Format on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		conform.format({ bufnr = args.buf })
-- 	end,
-- })

-- ":Format" command
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil

	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end

	conform.format({ async = true, lsp_fallback = true, range = range })
end, { range = true })
