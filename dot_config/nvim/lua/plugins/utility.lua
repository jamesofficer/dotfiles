-- utility plugins
vim.pack.add({
  "https://github.com/windwp/nvim-autopairs",   -- auto pairs
  "https://github.com/folke/todo-comments.nvim" -- highlight TODO/INFO/WARN comments
}, { confirm = false })

require("nvim-autopairs").setup()
require("todo-comments").setup()
