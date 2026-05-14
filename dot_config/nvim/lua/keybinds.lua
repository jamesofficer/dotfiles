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

vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "[G]it Lazy[g]it" })

-- quickfix
vim.keymap.set("n", "<leader>qa", function()
  vim.fn.setqflist({ {
    filename = vim.fn.expand("%"),
    lnum = vim.fn.line("."),
    col = vim.fn.col("."),
    text = vim.api.nvim_get_current_line(),
  } }, "a")
end, { desc = "[Q]uickfix [A]dd current line" })

vim.keymap.set("n", "<leader>qr", function()
  local list = vim.fn.getqflist()
  if #list == 0 then return end
  if vim.bo.filetype == "qf" then
    table.remove(list, vim.fn.line("."))
  else
    local file = vim.fn.expand("%:p")
    local lnum = vim.fn.line(".")
    for i = #list, 1, -1 do
      local entry_file = vim.fn.fnamemodify(vim.fn.bufname(list[i].bufnr), ":p")
      if entry_file == file and list[i].lnum == lnum then
        table.remove(list, i)
      end
    end
  end
  vim.fn.setqflist(list, "r")
end, { desc = "[Q]uickfix [R]emove entry" })

vim.keymap.set("n", "<leader>qq", function() Snacks.picker.qflist() end, { desc = "[Q]uickfix picker" })
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<cr>", { desc = "[Q]uickfix [N]ext" })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<cr>", { desc = "[Q]uickfix [P]rev" })
vim.keymap.set("n", "<leader>qx", function() vim.fn.setqflist({}, "r") end, { desc = "[Q]uickfix clear" })
