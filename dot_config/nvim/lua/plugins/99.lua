vim.pack.add({ "https://github.com/ThePrimeagen/99" }, { confirm = false })

local _99 = require("99")

_99.setup({
  provider = _99.Providers.ClaudeCodeProvider,
})

vim.keymap.set("v", "<leader>9v", function() _99.visual() end, { desc = "99 visual" })
vim.keymap.set("n", "<leader>9x", function() _99.stop_all_requests() end, { desc = "99 stop requests" })
vim.keymap.set("n", "<leader>9s", function() _99.search() end, { desc = "99 search" })
