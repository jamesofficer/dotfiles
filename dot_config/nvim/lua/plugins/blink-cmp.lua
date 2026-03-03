return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		keymap = {
			preset = "super-tab",
			["<CR>"] = { "accept", "fallback" },
			["<C-f>"] = {
				function(cmp)
					cmp.show()
				end,
			},
		},
	},
	-- optional: provides snippets for the snippet source
	-- dependencies = { "rafamadriz/friendly-snippets" },
	-- version = "*",
	--
	-- ---@module 'blink.cmp'
	-- ---@type blink.cmp.Config
	-- opts = {
	-- 	fuzzy = { implementation = "prefer_rust_with_warning" },
	--
	-- 	-- keymap = { preset = "default" },
	--
	-- 	keymap = {
	-- 		preset = "default",
	--
	-- 		["<C-f"] = {
	-- 			function(cmp)
	-- 				if cmp.is_visible() then
	-- 					cmp.hide()
	-- 				else
	-- 					cmp.show()
	-- 				end
	-- 			end,
	-- 		},
	--
	-- 		["<C-space>"] = {
	-- 			function(cmp)
	-- 				cmp.show()
	-- 			end,
	-- 		},
	--
	-- 		["<C-e>"] = { "hide", "fallback" },
	-- 		["<CR>"] = { "accept", "fallback" },
	--
	-- 		-- ["<Tab>"] = {
	-- 		-- 	function(cmp)
	-- 		-- 		return cmp.select_next()
	-- 		-- 	end,
	-- 		-- 	"snippet_forward",
	-- 		-- 	"fallback",
	-- 		-- },
	--
	-- 		["<Tab>"] = {
	-- 			"snippet_forward",
	-- 			function() -- sidekick next edit suggestion
	-- 				return require("sidekick").nes_jump_or_apply()
	-- 			end,
	-- 			function() -- if you are using Neovim's native inline completions
	-- 				if vim.lsp.inline_completion then
	-- 					return vim.lsp.inline_completion.get()
	-- 				end
	-- 			end,
	-- 			"fallback",
	-- 		},
	--
	-- 		["<S-Tab>"] = {
	-- 			function(cmp)
	-- 				return cmp.select_prev()
	-- 			end,
	-- 			"snippet_backward",
	-- 			"fallback",
	-- 		},
	--
	-- 		["<Up>"] = { "select_prev", "fallback" },
	-- 		["<Down>"] = { "select_next", "fallback" },
	--
	-- 		["<C-p>"] = { "select_prev", "fallback_to_mappings" },
	-- 		["<C-n>"] = { "select_next", "fallback_to_mappings" },
	--
	-- 		["<C-a>"] = { "scroll_documentation_up", "fallback" },
	-- 		["<C-h>"] = { "scroll_documentation_down", "fallback" },
	-- 	},
	--
	-- 	appearance = {
	-- 		nerd_font_variant = "mono",
	-- 	},
	--
	-- 	-- snippets = {
	-- 	-- 	preset = "mini_snippets",
	-- 	-- },
	--
	-- 	sources = {
	-- 		-- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
	-- 		-- default = { "lsp", "path", "snippets", "buffer" },
	-- 		default = { "snippets", "lsp", "path", "buffer" },
	-- 	},
	--
	-- 	signature = { enabled = true },
	--
	-- 	completion = {
	-- 		trigger = {
	-- 			show_on_keyword = true,
	-- 			show_on_trigger_character = true,
	-- 			show_on_insert_on_trigger_character = true,
	-- 		},
	--
	-- 		keyword = { range = "full" },
	--
	-- 		accept = { auto_brackets = { enabled = false } },
	--
	-- 		list = { selection = { preselect = false, auto_insert = false } },
	--
	-- 		documentation = { auto_show = true, auto_show_delay = 100 },
	--
	-- 		ghost_text = { enabled = false },
	--
	-- 		-- Use mini.icons
	-- 		menu = {
	-- 			auto_show = true,
	--
	-- 			draw = {
	-- 				components = {
	-- 					kind_icon = {
	-- 						text = function(ctx)
	-- 							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
	-- 							return kind_icon
	-- 						end,
	-- 						-- (optional) use highlights from mini.icons
	-- 						highlight = function(ctx)
	-- 							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
	-- 							return hl
	-- 						end,
	-- 					},
	-- 					kind = {
	-- 						-- (optional) use highlights from mini.icons
	-- 						highlight = function(ctx)
	-- 							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
	-- 							return hl
	-- 						end,
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
}
