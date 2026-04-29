-- colorscheme
vim.pack.add({
  { src = "https://github.com/everviolet/nvim", name = "evergarden" },
}, { confirm = false })

local ok, evergarden = pcall(require, "evergarden")
if not ok then return end

evergarden.setup({
  theme = {
    variant = "spring",
    accent = "green",
  },
  editor = {
    transparent_background = false,
    sign = { color = "none" },
    float = {
      color = "mantle",
      solid_border = false,
    },
    completion = {
      color = "surface0",
    },
  },
})

vim.cmd.colorscheme("evergarden")
