-- preserve split ratios on terminal resize
vim.pack.add({
  "https://github.com/adlrwbr/keep-split-ratio.nvim",
}, { confirm = false })

require("keep-split-ratio").setup({})

local enabled = true
vim.keymap.set("n", "<leader>uS", function()
  enabled = not enabled
  if enabled then
    require("keep-split-ratio").setup({})
    vim.notify("keep-split-ratio: ON")
  else
    pcall(vim.api.nvim_clear_autocmds, { group = "KeepSplitRatio_Save" })
    pcall(vim.api.nvim_clear_autocmds, { group = "KeepSplitRatio_Restore" })
    vim.notify("keep-split-ratio: OFF")
  end
end, { desc = "[U]I Toggle [S]plit Ratio Lock" })
