-- custom keybindings

-- jump multiple lines with J/K
vim.keymap.set("n", "J", "6j", { desc = "Move down 6 lines" })
vim.keymap.set("n", "K", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "<S-Down>", "6j", { desc = "Move down 6 lines" })
vim.keymap.set("n", "<S-Up>", "6k", { desc = "Move up 6 lines" })
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "[W]rite file" })
vim.keymap.set("n", "<leader>uy", "<cmd>silent %y+<cr>", { desc = "[Y]ank entire buffer to clipboard" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, { desc = "LSP Hover", silent = true })

-- splits
vim.keymap.set("n", "<leader>tv", "<CMD>:vsplit<CR>", { desc = "Split [V]ertically" })
vim.keymap.set("n", "<leader>th", "<CMD>:split<CR>", { desc = "Split [H]orizontally" })
vim.keymap.set("n", "<leader>tt", "<CMD>:wincmd w<CR>", { desc = "Cycle Splits" })

-- diagnostics navigation
vim.keymap.set("n", "&", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
vim.keymap.set("n", "|", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })

-- lazygit in a floating terminal
vim.keymap.set("n", "<leader>gg", function()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
  })
  vim.fn.termopen("lazygit", {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
      if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
    end,
  })
  vim.cmd("startinsert")
end, { desc = "[G]it Lazy[g]it" })
