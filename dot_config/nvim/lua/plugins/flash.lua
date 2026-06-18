-- flash.nvim: jump and treesitter selection
vim.pack.add({
  "https://github.com/folke/flash.nvim",
}, { confirm = false })

require("flash").setup()

-- distinguish label from matches: label = bright/inverted, matches = dim
local function set_flash_hl()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local accent = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })
  local label_fg = normal.bg or "#000000"
  local label_bg = accent.fg or normal.fg or "#7aa2f7"

  vim.api.nvim_set_hl(0, "FlashLabel", { fg = label_fg, bg = label_bg, bold = true })
  vim.api.nvim_set_hl(0, "FlashMatch", { link = "Comment" })
  vim.api.nvim_set_hl(0, "FlashCurrent", { link = "IncSearch" })
  vim.api.nvim_set_hl(0, "FlashBackdrop", { link = "Comment" })
end
set_flash_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_flash_hl })

local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<C-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
