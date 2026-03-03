-- goto-file-references.nvim
-- Find exported symbols in current file and show their references

local M = {}

-- Patterns to find exportable symbols in different languages
local patterns = {
	-- JavaScript/TypeScript/React
	{ pattern = "^export%s+function%s+([%w_]+)", type = "function" },
	{ pattern = "^export%s+const%s+([%w_]+)", type = "const" },
	{ pattern = "^export%s+class%s+([%w_]+)", type = "class" },
	{ pattern = "^export%s+default%s+function%s+([%w_]+)", type = "default function" },
	{ pattern = "^export%s+default%s+class%s+([%w_]+)", type = "default class" },
	{ pattern = "^export%s+async%s+function%s+([%w_]+)", type = "async function" },
	{ pattern = "^export%s+type%s+([%w_]+)", type = "type" },
	{ pattern = "^export%s+interface%s+([%w_]+)", type = "interface" },
	{ pattern = "^export%s+enum%s+([%w_]+)", type = "enum" },
	-- Named exports at end of file: export { Foo, Bar }
	{ pattern = "^export%s*{([^}]+)}", type = "named exports", multi = true },
	-- module.exports
	{ pattern = "module%.exports%s*=%s*([%w_]+)", type = "module.exports" },
	{ pattern = "module%.exports%.([%w_]+)%s*=", type = "module.exports property" },
	-- Python
	{ pattern = "^def%s+([%w_]+)%s*%(", type = "function" },
	{ pattern = "^class%s+([%w_]+)", type = "class" },
	{ pattern = "^async%s+def%s+([%w_]+)%s*%(", type = "async function" },
	-- Rust
	{ pattern = "^pub%s+fn%s+([%w_]+)", type = "pub fn" },
	{ pattern = "^pub%s+struct%s+([%w_]+)", type = "pub struct" },
	{ pattern = "^pub%s+enum%s+([%w_]+)", type = "pub enum" },
	{ pattern = "^pub%s+trait%s+([%w_]+)", type = "pub trait" },
	{ pattern = "^pub%s+type%s+([%w_]+)", type = "pub type" },
	{ pattern = "^pub%s+const%s+([%w_]+)", type = "pub const" },
	-- Go
	{ pattern = "^func%s+([A-Z][%w_]*)", type = "exported func" },
	{ pattern = "^type%s+([A-Z][%w_]*)%s+struct", type = "exported struct" },
	{ pattern = "^type%s+([A-Z][%w_]*)%s+interface", type = "exported interface" },
	{ pattern = "^var%s+([A-Z][%w_]*)", type = "exported var" },
	{ pattern = "^const%s+([A-Z][%w_]*)", type = "exported const" },
	-- Lua
	{ pattern = "^function%s+M%.([%w_]+)", type = "module function" },
	{ pattern = "^M%.([%w_]+)%s*=", type = "module property" },
	-- C/C++ headers
	{ pattern = "^[%w_]+%s+([%w_]+)%s*%(", type = "function declaration" },
}

-- Find all exported symbols in the current buffer
local function find_exports()
	local exports = {}
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	for line_num, line in ipairs(lines) do
		-- Skip empty lines and comments
		if line:match("^%s*$") or line:match("^%s*//") or line:match("^%s*#") or line:match("^%s*%-%-") then
			goto continue
		end

		-- Trim leading whitespace for pattern matching
		local trimmed = line:match("^%s*(.*)") or line

		for _, pat in ipairs(patterns) do
			local match = trimmed:match(pat.pattern)
			if match then
				if pat.multi then
					-- Handle multiple named exports like "export { Foo, Bar, Baz }"
					for name in match:gmatch("([%w_]+)") do
						-- Skip 'as' keyword and what follows it
						if name ~= "as" then
							table.insert(exports, {
								name = name,
								type = "named export",
								line = line_num,
							})
						end
					end
				else
					table.insert(exports, {
						name = match,
						type = pat.type,
						line = line_num,
					})
				end
				break
			end
		end

		::continue::
	end

	return exports
end

-- Find the position of a symbol in the buffer
local function find_symbol_position(symbol_name, line_num)
	local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
	if not line then
		return nil
	end

	local col = line:find(symbol_name, 1, true)
	if col then
		return { line_num - 1, col - 1 } -- 0-indexed
	end
	return nil
end

-- Go to references for a specific export
local function goto_references_for_export(export)
	local pos = find_symbol_position(export.name, export.line)
	if not pos then
		vim.notify("Could not find symbol position for: " .. export.name, vim.log.levels.WARN)
		return
	end

	-- Save current position
	local save_cursor = vim.api.nvim_win_get_cursor(0)

	-- Move cursor to the symbol
	vim.api.nvim_win_set_cursor(0, { pos[1] + 1, pos[2] })

	-- Trigger LSP references
	vim.lsp.buf.references()

	-- Note: We don't restore cursor position because the user wants to see references
end

-- Show picker and go to references
function M.find_references()
	local exports = find_exports()

	if #exports == 0 then
		vim.notify("No exported symbols found in this file", vim.log.levels.INFO)
		return
	end

	if #exports == 1 then
		-- Only one export, go directly to its references
		goto_references_for_export(exports[1])
		return
	end

	-- Multiple exports, show picker
	local items = {}
	for _, export in ipairs(exports) do
		table.insert(items, {
			label = string.format("%s (%s) - line %d", export.name, export.type, export.line),
			export = export,
		})
	end

	-- Try to use telescope if available
	local has_telescope, telescope = pcall(require, "telescope.pickers")
	if has_telescope then
		M.telescope_pick(exports)
		return
	end

	-- Try to use fzf-lua if available
	local has_fzf, fzf = pcall(require, "fzf-lua")
	if has_fzf then
		M.fzf_pick(exports)
		return
	end

	-- Fallback to vim.ui.select
	vim.ui.select(items, {
		prompt = "Select export to find references:",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if choice then
			goto_references_for_export(choice.export)
		end
	end)
end

-- Telescope picker
function M.telescope_pick(exports)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	pickers
		.new({}, {
			prompt_title = "Find References for Export",
			finder = finders.new_table({
				results = exports,
				entry_maker = function(entry)
					return {
						value = entry,
						display = string.format("%s (%s) - line %d", entry.name, entry.type, entry.line),
						ordinal = entry.name .. " " .. entry.type,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						goto_references_for_export(selection.value)
					end
				end)
				return true
			end,
		})
		:find()
end

-- FZF-lua picker
function M.fzf_pick(exports)
	local fzf = require("fzf-lua")

	local items = {}
	local lookup = {}
	for i, export in ipairs(exports) do
		local label = string.format("%s (%s) - line %d", export.name, export.type, export.line)
		table.insert(items, label)
		lookup[label] = export
	end

	fzf.fzf_exec(items, {
		prompt = "Find References> ",
		actions = {
			["default"] = function(selected)
				if selected and selected[1] then
					local export = lookup[selected[1]]
					if export then
						goto_references_for_export(export)
					end
				end
			end,
		},
	})
end

-- Setup function
function M.setup(opts)
	opts = opts or {}

	-- Default keymap
	local keymap = opts.keymap or "<leader>gr"

	-- Add custom patterns if provided
	if opts.patterns then
		for _, pat in ipairs(opts.patterns) do
			table.insert(patterns, pat)
		end
	end

	-- Set up the keymap
	vim.keymap.set("n", keymap, M.find_references, {
		desc = "Find references for file exports",
		silent = true,
	})
end

return M
