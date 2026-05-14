-- custom keybindings

-- jump multiple lines with J/K
vim.keymap.set("n", "J", "6j", { desc = "Move down 6 lines" })
vim.keymap.set("n", "K", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "<S-Down>", "6j", { desc = "Move down 6 lines" })
vim.keymap.set("n", "<S-Up>", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "[W]rite file" })
vim.keymap.set("n", "<leader>uy", "<cmd>silent %y+<cr>", { desc = "[Y]ank entire buffer to clipboard" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover", silent = true })

-- splits
vim.keymap.set("n", "<leader>tv", "<CMD>:vsplit<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<leader>th", "<CMD>:split<CR>", { desc = "Split [H]orizontally" })
vim.keymap.set("n", "<leader>tt", "<CMD>:wincmd w<CR>", { desc = "Cycle Splits" })

-- diagnostics navigation
vim.keymap.set("n", "&", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
vim.keymap.set("n", "|", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })

vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "[G]it Lazy[g]it" })
