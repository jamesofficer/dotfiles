-- find and replace across files
vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" }, { confirm = false })

require("grug-far").setup({})

vim.keymap.set("n", "<leader>fr", function()
  require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "[F]ind/replace current buffer" })

vim.keymap.set("n", "<leader>fR", function() require("grug-far").open() end,
  { desc = "[F]ind/replace project-wide" })

vim.keymap.set("v", "<leader>fr", function()
  require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
end, { desc = "[F]ind/replace selection in current buffer" })

vim.keymap.set("v", "<leader>fR", function() require("grug-far").with_visual_selection() end,
  { desc = "[F]ind/replace selection project-wide" })

vim.keymap.set("n", "<leader>fw", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "[F]ind/replace [w]ord under cursor (project)" })
