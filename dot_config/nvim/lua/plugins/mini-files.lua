-- file explorer
vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, { confirm = false })

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

-- notify LSP on file rename/move so imports/refs update
vim.api.nvim_create_autocmd("User", {
  pattern = { "MiniFilesActionRename", "MiniFilesActionMove" },
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

-- auto-accept "Always" on LSP rename confirmation (ts_ls "Update imports?")
local orig_show_message_request = vim.lsp.handlers["window/showMessageRequest"]
vim.lsp.handlers["window/showMessageRequest"] = function(err, result, ctx)
  for _, action in ipairs(result.actions or {}) do
    if action.title == "Always" then return action end
  end
  return orig_show_message_request(err, result, ctx)
end
