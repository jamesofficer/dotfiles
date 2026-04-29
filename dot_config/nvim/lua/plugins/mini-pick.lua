-- fuzzy finder
require("mini.pick").setup()
require("mini.extra").setup()
require("mini.visits").setup()

local pick = MiniPick.builtin
local extra = MiniExtra.pickers

-- frecency-sorted file picker (cwd-scoped, robust frecency = recency + frequency)
local function pick_frecent_files()
  local cwd = vim.fn.getcwd()
  local visited = MiniVisits.list_paths(cwd) -- already sorted by default frecency
  local seen = {}
  for _, p in ipairs(visited) do seen[p] = true end

  local items = vim.deepcopy(visited)

  -- append remaining cwd files (unvisited) so picker still fuzzy-matches everything
  local fd = vim.fn.executable("fd") == 1 and { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
    or { "rg", "--files", "--hidden", "--glob", "!.git" }
  local out = vim.fn.systemlist(fd)
  for _, rel in ipairs(out) do
    local abs = vim.fs.normalize(cwd .. "/" .. rel)
    if not seen[abs] then table.insert(items, abs) end
  end

  -- show paths relative to cwd
  local cwd_prefix = cwd .. "/"
  local display = {}
  for _, p in ipairs(items) do
    local rel = p
    if rel:sub(1, #cwd_prefix) == cwd_prefix then rel = rel:sub(#cwd_prefix + 1) end
    table.insert(display, { path = p, text = rel })
  end

  MiniPick.start({
    source = {
      name = "Files (frecency)",
      items = display,
      show = function(buf_id, items_to_show, query)
        MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
      end,
      choose = MiniPick.default_choose,
    },
  })
end

local function pick_lsp_references_without_imports()
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
end

local function pick_lsp_definitions()
  local params = vim.lsp.util.make_position_params(0, "utf-8")

  vim.lsp.buf_request_all(0, "textDocument/definition", params, function(results)
    local items = {}
    local seen = {}
    local cwd = vim.fn.getcwd() .. "/"

    for client_id, response in pairs(results) do
      local result = response.result
      if result and not vim.tbl_isempty(result) then
        local client = vim.lsp.get_client_by_id(client_id)
        local locations = vim.islist(result) and result or { result }
        local location_items = vim.lsp.util.locations_to_items(locations, client and client.offset_encoding or "utf-8")

        for _, item in ipairs(location_items) do
          local key = table.concat({
            item.filename,
            item.lnum,
            item.col,
            item.end_lnum or "",
            item.end_col or "",
          }, ":")

          if not seen[key] then
            seen[key] = true
            item.path = item.filename

            local rel_path = item.filename
            if rel_path:sub(1, #cwd) == cwd then rel_path = rel_path:sub(#cwd + 1) end

            item.text = string.format("%s:%d:%d %s", rel_path, item.lnum, item.col, item.text or "")
            table.insert(items, item)
          end
        end
      end
    end

    if #items == 0 then
      vim.notify("No definition found", vim.log.levels.INFO)
      return
    end

    if #items == 1 then
      MiniPick.default_choose(items[1])
      return
    end

    MiniPick.start({
      source = {
        name = "LSP (definitions)",
        items = items,
        show = function(buf_id, items_to_show, query)
          MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
        end,
        choose = MiniPick.default_choose,
      },
    })
  end)
end

vim.keymap.set("n", "<leader>ss", pick_frecent_files, { desc = "[S]earch Files ([S]mart frecency)", })
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
vim.keymap.set("n", "<leader>uc", function()
  MiniPick.start({
    source = {
      name = "Colorschemes",
      items = vim.fn.getcompletion("", "color"),
      choose = function(item)
        vim.cmd.colorscheme(item)
      end,
    },
  })
end, { desc = "[U]I [C]olorscheme", })

vim.keymap.set("n", "grr", pick_lsp_references_without_imports, { desc = "LSP References (no imports)", })
vim.keymap.set("n", "gd", pick_lsp_definitions, { desc = "LSP Definitions", })
