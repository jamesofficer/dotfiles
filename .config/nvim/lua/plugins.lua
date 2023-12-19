-- Lazy Package Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- LSP Plugins
local lsp_config = { "neovim/nvim-lspconfig" }
local mason_lsp_config = { "williamboman/mason-lspconfig.nvim" }
local cmp_nvim_lsp = { "hrsh7th/cmp-nvim-lsp" }
local lua_snip = { "L3MON4D3/LuaSnip" }

local nvim_cmp = {
	"hrsh7th/nvim-cmp",
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-a>"] = cmp.mapping.complete(),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
			}),
		})
	end,
}

local mason = {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
	end,
}

-- Formatting
local conform = {
	"stevearc/conform.nvim",
	opts = {},
}

local treesitter = {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			modules = {},
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
			ignore_install = {},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				-- Disable highlighting on large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
		})
	end,
}

local telescope = {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>r", builtin.resume, { desc = "[R]esume last search" })

		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sr", builtin.oldfiles, { desc = "[S]earch [R]ecent" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader><space>", builtin.buffers, { desc = "Open Buffers" })

		vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Document [S]ymbols" })
		vim.keymap.set("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace [S]ymbols" })

		telescope.load_extension("lsp_handlers")

		telescope.setup({
			defaults = {
				mappings = {
					n = {
						["<c-d>"] = require("telescope.actions").delete_buffer,
					},
					i = {
						["<c-d>"] = require("telescope.actions").delete_buffer,
					},
				},
			},
		})
	end,
}

local which_key = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require("which-key")
		wk.register({
			["<leader>"] = {
				c = {
					name = "Code",
				},
				d = {
					name = "Diagnostics",
				},
				g = {
					name = "Git",
				},
				s = {
					name = "Search",
				},
			},
		})
	end,
}

local flash = {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
    -- stylua: ignore
    keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
        { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
        {
            "R",
            mode = { "o", "x" },
            function() require("flash").treesitter_search() end,
            desc =
            "Treesitter Search"
        },
        {
            "<c-s>",
            mode = { "c" },
            function() require("flash").toggle() end,
            desc =
            "Toggle Flash Search"
        },
    },
}

local codeium = {
	"Exafunction/codeium.vim",
	event = "BufEnter",
	config = function()
		vim.g.codeium_disable_bindings = 1

		vim.keymap.set({ "i", "n" }, "<C-.>", function()
			return vim.fn["codeium#Accept"]()
		end, { expr = true })

		vim.keymap.set({ "i", "n" }, "<c-;>", function()
			return vim.fn["codeium#CycleCompletions"](1)
		end, { expr = true })

		vim.keymap.set({ "i", "n" }, "<c-'>", function()
			return vim.fn["codeium#CycleCompletions"](-1)
		end, { expr = true })

		vim.keymap.set("i", "<c-x>", function()
			return vim.fn["codeium#Clear"]()
		end, { expr = true })
	end,
}

local lazygit = {
	"kdheepak/lazygit.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
}

local comment = {
	"numToStr/Comment.nvim",
	lazy = false,
}

local no_neck_pain = {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	config = function()
		require("no-neck-pain").setup({
			width = 150,
		})
	end,
}

local telescope_lsp_handlers = {
	"gbrlsnchs/telescope-lsp-handlers.nvim",
}

local mini_files = {
	"echasnovski/mini.files",
	version = false,
	config = function()
		require("mini.files").setup()
	end,
}

local web_dev_icons = {
	"nvim-tree/nvim-web-devicons",
}

-- Neovim Development helpers (LUA api helpers etc)
local neodev = { "folke/neodev.nvim", opts = {} }

-- Run plugins
require("lazy").setup({
	require("colorschemes"),
	lsp_config,
	mason,
	mason_lsp_config,
	nvim_cmp,
	cmp_nvim_lsp,
	lua_snip,
	conform,
	treesitter,
	telescope,
	telescope_lsp_handlers,
	which_key,
	flash,
	codeium,
	lazygit,
	comment,
	neodev,
	no_neck_pain,
	mini_files,
	web_dev_icons,
})
