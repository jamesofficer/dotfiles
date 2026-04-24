-- fuzzy finder
require("mini.pick").setup()
require("mini.extra").setup()

local pick = MiniPick.builtin
local extra = MiniExtra.pickers

vim.keymap.set("n", "<leader>ss", pick.files, { desc = "[S]earch Files ([S]mart)", })
vim.keymap.set("n", "<leader>sa", pick.files, { desc = "[S]earch Files ([A]ll)", })
vim.keymap.set("n", "<leader><leader>", pick.buffers, { desc = "Buffers", })
vim.keymap.set("n", "<leader>sg", pick.grep_live, { desc = "[S]earch by [G]rep", })
vim.keymap.set("n", "<leader>sr", pick.resume, { desc = "[S]earch [R]esume", })
vim.keymap.set("n", "<leader>sh", pick.help, { desc = "[S]earch [H]elp", })

vim.keymap.set("n", "<leader>sd", function() extra.diagnostic({ scope = "current" }) end, { desc = "[S]earch [D]iagnostics (Buffer)", })
vim.keymap.set("n", "<leader>sD", function() extra.diagnostic({ scope = "all" }) end, { desc = "[S]earch [D]iagnostics (All)", })
vim.keymap.set("n", "<leader>sy", function() extra.lsp({ scope = "document_symbol" }) end, { desc = "[S]earch LSP S[y]mbols", })
vim.keymap.set("n", "<leader>sY", function() extra.lsp({ scope = "workspace_symbol" }) end, { desc = "[S]earch LSP S[Y]mbols (Workspace)", })
vim.keymap.set("n", "<leader>sc", extra.oldfiles, { desc = "[S]earch Re[c]ent Files", })
vim.keymap.set("n", "<leader>sR", extra.registers, { desc = "[S]earch [R]egisters", })
vim.keymap.set("n", "<leader>sl", function() extra.buf_lines({ scope = "current" }) end, { desc = "[S]earch [L]ines", })
vim.keymap.set("n", "<leader>sm", extra.marks, { desc = "[S]earch [M]arks", })
vim.keymap.set("n", "<leader>sq", function() extra.list({ scope = "quickfix" }) end, { desc = "[S]earch [Q]uickfix", })
vim.keymap.set("n", "<leader>sj", function() extra.list({ scope = "jump" }) end, { desc = "[S]earch [J]umps", })

vim.keymap.set("n", "grr", function()
  local import_patterns = { "^import ", "^from ", "require%(", "^#include " }
  local cursor_file = vim.api.nvim_buf_get_name(0)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.lsp.buf.references(nil, {
    on_list = function(data)
      local items = vim.tbl_filter(function(item)
        if item.filename == cursor_file and item.lnum == cursor_line then return false end
        local text = vim.trim(item.text or "")
        for _, pat in ipairs(import_patterns) do
          if text:match(pat) then return false end
        end
        return true
      end, data.items)

      local cwd = vim.fn.getcwd() .. "/"
      for _, item in ipairs(items) do
        item.path = item.filename
        local rel_path = item.filename
        if rel_path:sub(1, #cwd) == cwd then rel_path = rel_path:sub(#cwd + 1) end
        item.text = string.format("%s:%d:%d %s", rel_path, item.lnum, item.col, item.text)
      end

      MiniPick.start({
        source = {
          name = "LSP (references)",
          items = items,
          show = function(buf_id, items_to_show, query)
            MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
          end,
          choose = function(item)
            MiniPick.default_choose(item)
            vim.fn.chdir(vim.fn.getcwd())
          end,
        },
      })
    end,
  })
end, { desc = "LSP References (no imports)", })
vim.keymap.set("n", "gd", function() extra.lsp({ scope = "definition" }) end, { desc = "LSP Definitions", })
