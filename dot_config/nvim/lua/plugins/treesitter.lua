-- formatting and syntax highlighting
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } }, { confirm = false })

local ts_parsers = {
  "lua", "c", "rust", "go",
  "vim", "vimdoc", "query",
  "markdown", "markdown_inline",
  "typescript", "tsx", "javascript",
  "html", "css", "json", "yaml", "toml",
}

local nts = require("nvim-treesitter")
nts.install(ts_parsers)

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function()
    nts.update()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start(args.buf)
    end
  end,
})

-- incremental selection (grow/shrink visual selection by treesitter node)
-- nvim-treesitter's `main` branch dropped the old configs.setup()
-- incremental_selection module, so this reimplements it directly.
-- state is per-buffer: `stack` is the chain of nodes we've grown through,
-- `origin` is the selection we started from so shrinking can get back to it.
local ts_sel = { buf = nil, stack = {}, origin = nil }

local function ts_reset()
  ts_sel.buf = nil
  ts_sel.stack = {}
  ts_sel.origin = nil
end

-- the live visual selection, 0-indexed and normalised so start <= end.
-- reads getpos("v")/getpos(".") rather than the '< '> marks: those only get
-- written when visual mode is left, so mid-selection they hold stale bounds.
local function ts_visual_range()
  local anchor = vim.fn.getpos("v")
  local cursor = vim.fn.getpos(".")
  local srow, scol = anchor[2] - 1, anchor[3] - 1
  local erow, ecol = cursor[2] - 1, cursor[3] - 1
  if srow > erow or (srow == erow and scol > ecol) then
    srow, scol, erow, ecol = erow, ecol, srow, scol
  end
  return srow, scol, erow, ecol
end

-- node ranges end exclusive, visual selections end inclusive
local function ts_node_range_inclusive(node)
  local srow, scol, erow, ecol = node:range()
  if ecol == 0 and erow > srow then
    erow = erow - 1
    local line = vim.api.nvim_buf_get_lines(0, erow, erow + 1, false)[1] or ""
    ecol = math.max(#line - 1, 0)
  else
    ecol = math.max(ecol - 1, 0)
  end
  return srow, scol, erow, ecol
end

-- reselecting means leaving and re-entering visual mode, which would otherwise
-- trip the ModeChanged reset below and wipe the stack on every step
local ts_reselecting = false

local function ts_select_range(srow, scol, erow, ecol)
  ts_reselecting = true
  if vim.fn.mode():match("^[vV\22]") then
    vim.cmd("normal! \27")
  end
  vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { erow + 1, ecol })
  ts_reselecting = false
end

local function ts_select_node(node)
  ts_select_range(ts_node_range_inclusive(node))
end

-- does the node span strictly more than the given (inclusive) range?
local function ts_node_is_bigger(node, srow, scol, erow, ecol)
  local nsrow, nscol, nerow, necol = node:range()
  local starts_at_or_before = nsrow < srow or (nsrow == srow and nscol <= scol)
  local ends_at_or_after = nerow > erow or (nerow == erow and necol >= ecol + 1)
  if not (starts_at_or_before and ends_at_or_after) then
    return false
  end
  local same = nsrow == srow and nscol == scol and nerow == erow and necol == ecol + 1
  return not same
end

local function ts_grow_selection()
  local buf = vim.api.nvim_get_current_buf()
  if ts_sel.buf ~= buf then
    ts_reset()
    ts_sel.buf = buf
  end

  local srow, scol, erow, ecol = ts_visual_range()
  local node

  if #ts_sel.stack > 0 then
    node = ts_sel.stack[#ts_sel.stack]:parent()
  else
    ts_sel.origin = { srow, scol, erow, ecol }
    local ok, found = pcall(vim.treesitter.get_node, { bufnr = buf, pos = { srow, scol } })
    node = ok and found or nil
  end

  -- climb until we find something genuinely larger, so repeated presses always
  -- make progress instead of re-selecting the same range
  while node and not ts_node_is_bigger(node, srow, scol, erow, ecol) do
    node = node:parent()
  end
  if not node then
    return
  end

  table.insert(ts_sel.stack, node)
  ts_select_node(node)
end

local function ts_shrink_selection()
  if #ts_sel.stack == 0 then
    return
  end
  table.remove(ts_sel.stack)
  local node = ts_sel.stack[#ts_sel.stack]
  if node then
    ts_select_node(node)
  elseif ts_sel.origin then
    ts_select_range(unpack(ts_sel.origin))
  end
end

vim.keymap.set("x", "v", ts_grow_selection, { desc = "Expand selection to parent treesitter node" })
vim.keymap.set("x", "V", ts_shrink_selection, { desc = "Shrink selection to previous treesitter node" })

-- start a fresh chain whenever visual mode is entered from normal
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:*",
  callback = function()
    if ts_reselecting then
      return
    end
    if vim.v.event.old_mode == "n" and vim.v.event.new_mode:match("^[vV\22]") then
      ts_reset()
    end
  end,
})
