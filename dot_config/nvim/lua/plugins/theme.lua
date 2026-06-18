-- colorscheme
vim.pack.add({
  { src = "https://github.com/everviolet/nvim",            name = "evergarden" },
  { src = "https://github.com/Verf/deepwhite.nvim",        name = "deepwhite" },
  { src = "https://github.com/loctvl842/monokai-pro.nvim", name = "monokai-pro" },
  { src = "https://github.com/calind/selenized.nvim",      name = "selenized" },
  { src = "https://github.com/oxfist/night-owl.nvim",      name = "night-owl" },
  { src = "https://github.com/projekt0n/github-nvim-theme", name = "github-theme" },
  { src = "https://github.com/EdenEast/nightfox.nvim",     name = "nightfox" },
  { src = "https://github.com/sainnhe/everforest",         name = "everforest" },
  { src = "https://github.com/boningmaple/mac-clear",      name = "mac-clear" },
}, { confirm = false })

pcall(function()
  require("github-theme").setup({})
end)

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

pcall(function()
  require("monokai-pro").setup({
    filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
  })
end)

pcall(function()
  require("deepwhite").setup({
    low_blue_light = true,
  })
end)

-- deepwhite overrides: bold functions + custom bg
local function deepwhite_overrides()
  if vim.g.colors_name ~= "deepwhite" then return end
  local groups = {
    "@function", "@function.call", "@function.builtin",
    "@method", "@method.call",
    "@constructor",
    "@lsp.type.function", "@lsp.type.method",
    "Function",
  }
  for _, g in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    hl.bold = true
    vim.api.nvim_set_hl(0, g, hl)
  end

  local bg = "#F7F4ED"
  for _, g in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer", "LineNr" }) do
    local hl = vim.api.nvim_get_hl(0, { name = g, link = false })
    hl.bg = bg
    vim.api.nvim_set_hl(0, g, hl)
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { pattern = "deepwhite", callback = deepwhite_overrides })
