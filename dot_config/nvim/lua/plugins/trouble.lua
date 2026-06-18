-- diagnostics, references, lsp results in a panel
vim.pack.add({ "https://github.com/folke/trouble.nvim" }, { confirm = false })

require("trouble").setup({})

local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end

map("<leader>dd", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
map("<leader>dD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
map("<leader>ds", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)")
map("<leader>dl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP (Trouble)")
map("<leader>dL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
map("<leader>dQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")

map("&", function() vim.diagnostic.jump({ count = 1 }) end, "Next Diagnostic")
map("|", function() vim.diagnostic.jump({ count = -1 }) end, "Prev Diagnostic")
