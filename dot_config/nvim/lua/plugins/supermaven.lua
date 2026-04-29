vim.pack.add({
  "https://github.com/supermaven-inc/supermaven-nvim",
}, { confirm = false })

require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<C-a>",
  },
  color = {
    suggestion_color = "#5C666C",
    cterm = 244,
  },
  log_level = "off",
})
