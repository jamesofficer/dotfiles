-- INFO: options
require("options")
require("keybinds")

-- INFO: plugins
vim.cmd.colorscheme("catppuccin")

require("plugins.treesitter")
require("plugins.blink")
require("plugins.lsp")
require("plugins.mini")
require("plugins.mini-pick")
require("plugins.mini-clue")
require("plugins.mini-files")
require("plugins.lualine")
require("plugins.utility")

-- uncomment to enable automatic plugin updates
-- vim.pack.update()
