-- flash.nvim: jump and treesitter selection
vim.pack.add({
  "https://github.com/folke/flash.nvim",
}, { confirm = false })

require("flash").setup()

-- make the jump label stand out — invert Normal so it adapts to light/dark themes
local function set_flash_hl()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  vim.api.nvim_set_hl(0, "FlashLabel", { fg = normal.bg, bg = normal.fg, bold = true })
end
set_flash_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_flash_hl })

local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<C-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
