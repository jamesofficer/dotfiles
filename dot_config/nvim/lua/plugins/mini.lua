-- mini.nvim base setup (package + icons)
vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
}, { confirm = false })

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
require("mini.cursorword").setup()

local ai = require("mini.ai")
ai.setup({
  custom_textobjects = {
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
  },
})

require("mini.surround").setup({
  mappings = {
    add = "za",
    delete = "zd",
    find = "zf",
    find_left = "zF",
    highlight = "zh",
    replace = "zr",
    update_n_lines = "zn",
  },
})

require("mini.indentscope").setup({
  draw = {
    delay = 0,
    animation = require("mini.indentscope").gen_animation.none(),
  },
  symbol = "│",
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#3B4449", nocombine = true })
    vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#2A3135", nocombine = true })
    vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#323B40", nocombine = true })
  end,
})

vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#3B4449", nocombine = true })
vim.api.nvim_set_hl(0, "MiniCursorword", { bg = "#2A3135", nocombine = true })
vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = "#323B40", nocombine = true })
