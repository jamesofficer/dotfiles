-- diff viewer
vim.pack.add({ "https://github.com/esmuellert/codediff.nvim" }, { confirm = false })

require("codediff").setup({
  diff = {
    layout = "side-by-side",
  },
})

vim.keymap.set("n", "<leader>gm", function()
  vim.cmd("CodeDiff file main")
end, { desc = "[G]it diff vs [m]ain (current file)" })

vim.keymap.set("n", "<leader>gM", function()
  vim.cmd("CodeDiff main")
end, { desc = "[G]it diff vs [M]ain (all files)" })

vim.keymap.set("n", "<leader>gd", function()
  vim.cmd("CodeDiff")
end, { desc = "[G]it [d]iff (working changes)" })

vim.keymap.set("n", "<leader>gh", function()
  vim.cmd("CodeDiff history")
end, { desc = "[G]it [h]istory" })
