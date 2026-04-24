-- file explorer
local minifiles = require("mini.files")
minifiles.setup({
  mappings = {
    close = "q",
    go_in = "<Right>",
    go_in_plus = "L",
    go_out = "<Left>",
    go_out_plus = "H",
    reset = "<BS>",
    reveal_cwd = "@",
    show_help = "g?",
    synchronize = "=",
    trim_left = "<",
    trim_right = ">",
  },
  windows = {
    max_number = math.huge,
    preview = false,
    width_focus = 50,
    width_nofocus = 15,
  },
  options = {
    use_as_default_explorer = true,
  },
})

vim.keymap.set("n", "<leader>e", function()
  minifiles.open(vim.api.nvim_buf_get_name(0))
end, { desc = "Fil[e] Browser" })
