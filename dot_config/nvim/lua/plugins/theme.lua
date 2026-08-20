-- colorschemes
vim.pack.add({
  { src = "https://github.com/everviolet/nvim",                     name = "evergarden" },
  { src = "https://github.com/Verf/deepwhite.nvim",                 name = "deepwhite" },
  { src = "https://github.com/loctvl842/monokai-pro.nvim",          name = "monokai-pro" },
  { src = "https://github.com/calind/selenized.nvim",               name = "selenized" },
  { src = "https://github.com/oxfist/night-owl.nvim",               name = "night-owl" },
  { src = "https://github.com/projekt0n/github-nvim-theme",         name = "github-theme" },
  { src = "https://github.com/EdenEast/nightfox.nvim",              name = "nightfox" },
  { src = "https://github.com/sainnhe/everforest",                  name = "everforest" },
  { src = "https://github.com/boningmaple/mac-clear",               name = "mac-clear" },
  { src = "https://github.com/ellisonleao/gruvbox.nvim",            name = "gruvbox" },
  { src = "https://github.com/rose-pine/neovim",                    name = "rose-pine" },
  { src = "https://github.com/sainnhe/edge",                        name = "edge" },
  { src = "https://github.com/g-kirti/hardhat.nvim",                name = "hardhat" },
  { src = "https://github.com/Mofiqul/adwaita.nvim",                name = "adwaita" },
  { src = "https://github.com/polirritmico/monokai-nightasty.nvim", name = "monokai-nightasty" },
  { src = "https://github.com/serhez/teide.nvim",                   name = "teide" },
}, { confirm = false })

local DEFAULT_COLORSCHEME = "teide-dimmed"

-- per-theme setup, keyed by a lua pattern matched against the colorscheme name.
-- these run lazily (see the ColorSchemePre autocmd below) so switching themes
-- with <leader>uc doesn't pay for configuring the other fourteen.
local theme_configs = {
  ["^evergarden"] = function()
    require("evergarden").setup({
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
  end,

  ["^everforest"] = function()
    vim.g.everforest_background = "medium" -- hard | medium | soft
    vim.g.everforest_enable_italic = true
    vim.g.everforest_better_performance = 1
    vim.g.everforest_ui_contrast = "high"
    vim.g.everforest_float_style = "dim"
  end,

  ["^deepwhite"] = function()
    require("deepwhite").setup({ low_blue_light = true })
  end,

  ["^gruvbox"] = function()
    require("gruvbox").setup({})
  end,

  ["^rose%-pine"] = function()
    require("rose-pine").setup({})
  end,

  ["^github_"] = function()
    require("github-theme").setup({})
  end,

  ["^monokai%-pro"] = function()
    require("monokai-pro").setup({
      filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
    })
  end,

  ["^teide"] = function()
    require("teide").setup({
      style = "dimmed", -- darker | dark | dimmed | light
    })
  end,
}

local configured = {}

vim.api.nvim_create_autocmd("ColorSchemePre", {
  callback = function(args)
    local name = args.match
    if configured[name] then return end

    for pattern, configure in pairs(theme_configs) do
      if name:match(pattern) then
        configured[name] = true
        local ok, err = pcall(configure)
        if not ok then
          vim.notify("Theme setup failed for " .. name .. ": " .. tostring(err), vim.log.levels.WARN)
        end
        return
      end
    end
  end,
})

-- deepwhite overrides: bold functions + custom bg
local function deepwhite_overrides()
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

vim.cmd.colorscheme(DEFAULT_COLORSCHEME)
