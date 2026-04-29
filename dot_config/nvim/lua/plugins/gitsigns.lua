vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" }, { confirm = false })

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")
    vim.keymap.set("n", "<leader>gb", gitsigns.toggle_current_line_blame,
      { buffer = bufnr, desc = "[G]it toggle line [b]lame" })
  end,
})
