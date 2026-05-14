-- find and replace across files
vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" }, { confirm = false })

require("grug-far").setup({})

vim.keymap.set("n", "<leader>rr", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "[R]eplace in current buffe[r]" })

vim.keymap.set("n", "<leader>rR", function() require("grug-far").open() end,
  { desc = "[R]eplace project-wide" })

vim.keymap.set("v", "<leader>rr", function()
  require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "[R]eplace selection in current buffe[r]" })

vim.keymap.set("v", "<leader>rR", function() require("grug-far").with_visual_selection() end,
  { desc = "[R]eplace selection project-wide" })

vim.keymap.set("n", "<leader>rw", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "[R]eplace [w]ord under cursor (project)" })
