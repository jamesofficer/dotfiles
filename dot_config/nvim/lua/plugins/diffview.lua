-- diff viewer
vim.pack.add({ "https://github.com/sindrets/diffview.nvim" }, { confirm = false })

require("diffview").setup({})

vim.keymap.set("n", "<leader>gm", function()
  vim.cmd("DiffviewOpen main -- " .. vim.fn.expand("%"))
end, { desc = "[G]it diff vs [m]ain (current file)" })
