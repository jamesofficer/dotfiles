-- leetcode inside neovim
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/kawre/leetcode.nvim",
}, { confirm = false })

require("leetcode").setup({
  lang = "typescript",
  picker = { provider = "snacks-picker" },
  injector = {
    ["typescript"] = {
      before = true,
    },
  },
})

local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end

map("<leader>lm", "<cmd>Leet menu<cr>", "[L]eetcode [M]enu")
map("<leader>ll", "<cmd>Leet list<cr>", "[L]eetcode [L]ist problems")
map("<leader>ld", "<cmd>Leet daily<cr>", "[L]eetcode [D]aily question")
map("<leader>lr", "<cmd>Leet run<cr>", "[L]eetcode [R]un tests")
map("<leader>ls", "<cmd>Leet submit<cr>", "[L]eetcode [S]ubmit")
map("<leader>li", "<cmd>Leet info<cr>", "[L]eetcode question [I]nfo")
map("<leader>lc", "<cmd>Leet console<cr>", "[L]eetcode [C]onsole")
map("<leader>lt", "<cmd>Leet tabs<cr>", "[L]eetcode [T]abs")
map("<leader>lq", "<cmd>Leet exit<cr>", "[L]eetcode [Q]uit")
