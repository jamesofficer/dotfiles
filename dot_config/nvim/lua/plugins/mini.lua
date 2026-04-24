-- mini.nvim base setup (package + icons)
vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
}, { confirm = false })

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
