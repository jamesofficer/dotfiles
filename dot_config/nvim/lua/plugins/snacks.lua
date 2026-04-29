-- snacks.nvim picker
vim.pack.add({
  "https://github.com/folke/snacks.nvim",
}, { confirm = false })

require("snacks").setup({
  picker = { enabled = true },
})

-- prevent native autocomplete popup inside picker input
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker_input",
  callback = function(args)
    vim.bo[args.buf].autocomplete = false
  end,
})

local picker = Snacks.picker
local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end

-- files / buffers
map("<leader>ss", function()
  picker.smart({
    filename_first = true,
    matcher = { cwd_bonus = true, frecency = true },
    filter = { cwd = true },
  })
end, "[S]earch Files ([S]mart frecency)")
map("<leader>sa", function() picker.files() end, "[S]earch Files ([A]ll)")
map("<leader>sS", function() picker.git_files() end, "Files (in Git)")
map("<leader>sc", function() picker.recent() end, "[S]earch Re[c]ent Files")
map("<leader>se", function() picker.explorer() end, "File [E]xplorer")
map("<leader><leader>", function() picker.buffers() end, "Buffers")

-- search
map("<leader>sg", function() picker.grep() end, "[S]earch by [G]rep")
map("<leader>sl", function() picker.lines() end, "[S]earch [L]ines")
map("<leader>sh", function() picker.search_history() end, "Search [H]istory")
map("<leader>sr", function() picker.resume() end, "[S]earch [R]esume")

-- diagnostics
map("<leader>sd", function() picker.diagnostics_buffer() end, "[S]earch [D]iagnostics (Buffer)")
map("<leader>sD", function() picker.diagnostics() end, "[S]earch [D]iagnostics (All)")

-- lsp
map("<leader>sy", function()
  picker.lsp_symbols({
    filter = {
      default = { "Class", "Field", "Function", "Interface", "Method" },
      markdown = true,
      help = true,
    },
  })
end, "[S]earch LSP S[y]mbols")
map("<leader>sY", function() picker.lsp_workspace_symbols() end, "[S]earch LSP S[Y]mbols (Workspace)")
map("grr", function() picker.lsp_references() end, "LSP References")
map("gd", function() picker.lsp_definitions() end, "LSP Definitions")
map("gI", function() picker.lsp_implementations() end, "LSP Implementations")
map("gy", function() picker.lsp_type_definitions() end, "LSP Type Definitions")

-- lists
map("<leader>sm", function() picker.marks() end, "[S]earch [M]arks")
map("<leader>sq", function() picker.qflist() end, "[S]earch [Q]uickfix")
map("<leader>sj", function() picker.jumps() end, "[S]earch [J]umps")
map("<leader>sR", function() picker.registers() end, "[S]earch [R]egisters")
map("<leader>su", function() picker.undo() end, "[S]earch [U]ndo History")

-- git
map("<leader>gs", function() picker.git_status() end, "[G]it [S]tatus")
map("<leader>gl", function() picker.git_log() end, "[G]it [L]og")

-- misc
map("<leader>sA", function() picker() end, "All Pickers")
map("<leader>sH", function() picker.pickers() end, "Picker [H]istory")
map("<leader>uc", function() picker.colorschemes() end, "[U]I [C]olorscheme")
