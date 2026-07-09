-- treesitter/LSP-powered refactoring operations
vim.pack.add({
  "https://github.com/lewis6991/async.nvim",
  "https://github.com/ThePrimeagen/refactoring.nvim",
}, { confirm = false })

-- patch missing tsx function_declaration (alias to javascript)
local function tsx_function_declaration(opts)
  local iter = vim.iter
  local args = iter(opts.args):map(function(v) return v.identifier end):join(", ")
  return ([[
%s%s(%s){
%s
}]]):format(opts.method and "" or "function ", opts.name, args, opts.body)
end

require("refactoring").setup({
  refactor = {
    extract_func = {
      code_generation = {
        function_declaration = {
          tsx = tsx_function_declaration,
        },
      },
    },
  },
})

local keymap = vim.keymap

-- single-key select refactor menu (avoids collision with grug-far <leader>rr/rR/rw)
keymap.set({ "n", "x" }, "<leader>rs", function()
  return require("refactoring").select_refactor()
end, { desc = "[R]efactor [S]elect" })

-- debug print var/expr/location under <leader>p
keymap.set("n", "<leader>pv", function()
  return require("refactoring.debug").print_var({ output_location = "below" }) .. "iw"
end, { desc = "Debug [P]rint [V]ar below", expr = true })
keymap.set("x", "<leader>pv", function()
  return require("refactoring.debug").print_var({ output_location = "below" })
end, { desc = "Debug [P]rint [V]ar below", expr = true })

keymap.set("n", "<leader>pV", function()
  return require("refactoring.debug").print_var({ output_location = "above" }) .. "iw"
end, { desc = "Debug [P]rint [V]ar above", expr = true })
keymap.set("x", "<leader>pV", function()
  return require("refactoring.debug").print_var({ output_location = "above" })
end, { desc = "Debug [P]rint [V]ar above", expr = true })

keymap.set("n", "<leader>pp", function()
  return require("refactoring.debug").print_loc({ output_location = "below" })
end, { desc = "Debug [P]rint location", expr = true })

keymap.set("n", "<leader>pc", function()
  return require("refactoring.debug").cleanup({ restore_view = true })
end, { desc = "Debug [P]rint [C]leanup", expr = true, remap = true })
