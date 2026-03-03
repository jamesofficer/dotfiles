vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("n", "<leader>w", "<CMD>:w<CR>", { desc = "Save file" })

vim.keymap.set("n", "<S-Up>", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "<S-Down>", "6j", { desc = "Move down 6 lines" })
vim.keymap.set("n", "K", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "J", "6j", { desc = "Move down 6 lines" })

vim.keymap.set("n", "<leader>tv", "<CMD>:vsplit<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<leader>th", "<CMD>:split<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<leader>tt", "<CMD>:wincmd w<CR>", { desc = "Cycle Splits" })
vim.keymap.set("n", "<leader>tf", "<CMD>:wincmd |<CR>", { desc = "[F]ullscreen (Maximise Width)" })
vim.keymap.set("n", "<leader>te", "<CMD>:wincmd =<CR>", { desc = "[E]qualize Splits" })

vim.keymap.set("n", "<leader>t<Up>", "<CMD>:wincmd k<CR>", { desc = "Go to Top Split" })
vim.keymap.set("n", "<leader>t<Down>", "<CMD>:wincmd j<CR>", { desc = "Go to Bottom Split" })
vim.keymap.set("n", "<leader>t<Left>", "<CMD>:wincmd h<CR>", { desc = "Go to Left Split" })
vim.keymap.set("n", "<leader>t<Right>", "<CMD>:wincmd l<CR>", { desc = "Go to Bottom Split" })

vim.keymap.set("n", "<leader>uy", ":%y+<CR>", { desc = "Yank entire buffer to clipboard" })

vim.keymap.set("n", "<leader>bd", "<CMD>:bd<CR>", { desc = "[D]elete Buffer" })

vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]ename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

vim.keymap.set("n", "<leader>ll", "`.", { desc = "[L]ast Edit [L]ocation" })
vim.keymap.set("n", "<leader>ln", "`[", { desc = "Beggining of last yanked/edited line" })
vim.keymap.set("n", "<leader>li", "`]", { desc = "End of last yanked/edited line" })

vim.keymap.set("n", "<leader>cR", function()
	vim.lsp.buf.code_action({
		context = {
			only = { "source", "refactor", "quickfix" },
		},
	})
end, { desc = "[C]ode [R]efactor" })

vim.keymap.set("n", "<leader>cl", function()
	local view = vim.fn.winsaveview()
	vim.cmd([[g/console./norm gcc]])
	vim.fn.winrestview(view)
end, { desc = "Toggle comments on all logs" })

vim.keymap.set("n", "<leader>cu", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.removeUnused" },
			diagnostics = {},
		},
	})
end, { desc = "Remove unused imports (vtsls)" })

vim.keymap.set("n", "<leader>ci", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.addMissingImports" },
			diagnostics = {},
		},
	})
end, { desc = "[I]mport missing imports (vtsls)" })

vim.keymap.set("n", "<leader>cf", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.fixAll.biome" },
			diagnostics = {},
		},
	})
end, { desc = "[F]ix all auto-fixable issues (Biome)" })

vim.keymap.set("n", "<leader>co", function()
	require("utils").organize_imports()
end, { desc = "Organize imports (Biome → TypeScript)" })

vim.keymap.set("n", "<leader>up", "<CMD>:Precognition toggle<CR>", { desc = "Toggle Precognition" })
vim.keymap.set("n", "<leader>uh", "<CMD>:Hardtime toggle<CR>", { desc = "Toggle Hardtime" })
vim.keymap.set("n", "<leader>ut", "<CMD>:Typr<CR>", { desc = "Toggle Typr" })

vim.keymap.set("n", "<leader>uk", function()
	local lazy_config = require("lazy.core.config")
	local plugin = lazy_config.plugins["keep-split-ratio.nvim"]
	if plugin then
		if plugin._.loaded then
			vim.cmd("Lazy unload keep-split-ratio.nvim")
			vim.notify("Keep Split Ratio: Disabled", vim.log.levels.INFO)
		else
			vim.cmd("Lazy load keep-split-ratio.nvim")
			vim.notify("Keep Split Ratio: Enabled", vim.log.levels.INFO)
		end
	end
end, { desc = "Toggle Keep Split Ratio" })
vim.keymap.set("n", "<leader>ue", "<C-w>=", { desc = "Equalize splits" })
