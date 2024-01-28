vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "<C-s>", "<CMD>:w<CR>", { desc = "Save file" })

-- vim.keymap.set("n", "<C-k>", "6k", { desc = "Move down 6 lines" })
-- vim.keymap.set("n", "<C-j>", "6j", { desc = "Move up 6 lines" })

vim.keymap.set("n", "K", "6k", { desc = "Move down 6 lines" })
vim.keymap.set("n", "J", "6j", { desc = "Move up 6 lines" })

vim.keymap.set("n", "<leader>gg", "<CMD>:LazyGit<CR>", { desc = "Toggle Lazygit" })

vim.keymap.set("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating [D]iagnostic [M]essage" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[R]ename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

vim.keymap.set("n", "<leader>e", "<CMD>:lua MiniFiles.open()<CR>", { desc = "Open file browser" })

-- No Arrow Keys
vim.keymap.set("n", "<Left>", ":echo 'Use h'<CR>")
vim.keymap.set("n", "<Right>", ":echo 'Use l'<CR>")
vim.keymap.set("n", "<Up>", ":echo 'Use k'<CR>")
vim.keymap.set("n", "<Down>", ":echo 'Use j'<CR>")
vim.keymap.set("i", "<Left>", "<c-o>:echo 'Use h'<CR>")
vim.keymap.set("i", "<Right>", "<c-o>:echo 'Use l'<CR>")
vim.keymap.set("i", "<Up>", "<c-o>:echo 'Use k'<CR>")
vim.keymap.set("i", "<Down>", "<c-o>:echo 'Use j'<CR>")

-- LSP Keybindings
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP Actions",
	callback = function(event)
		local opts = { buffer = event.buf }

		vim.keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
		vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

		vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
		vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
		vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
	end,
})

-- No Neck Pain
vim.keymap.set("n", "<leader>zz", "<CMD>:NoNeckPain<CR>", { desc = "Toggle Centered Layout ([Z]en Mode)" })
vim.keymap.set("n", "<leader>z1", "<CMD>:NoNeckPainResize 100<CR>", { desc = "Resize (Small)" })
vim.keymap.set("n", "<leader>z2", "<CMD>:NoNeckPainResize 150<CR>", { desc = "Resize (Medium)" })
vim.keymap.set("n", "<leader>z3", "<CMD>:NoNeckPainResize 200<CR>", { desc = "Resize (Large)" })
