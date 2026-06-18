-- formatted TS error popups
vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/OlegGulevskyy/better-ts-errors.nvim",
}, { confirm = false })

require("better-ts-errors").setup({
  keymaps = {
    toggle = "<leader>dv",
    go_to_definition = "<leader>dx",
  },
})
