-- wash out unfocused splits: fade Normal/StatusLine/gutter away from the
-- colorscheme's background for inactive windows. derives the washed color from
-- whatever colorscheme is active so it keeps working when switching between
-- evergarden/everforest/etc. dark themes fade toward white, light themes fade
-- toward black -- fading a near-white background toward white is invisible.
local WASH_AMOUNT = 0.035
local WHITE = 0xFFFFFF
local BLACK = 0x000000

local function blend(color, target, amount)
  local r = math.floor(color / 65536) % 256
  local g = math.floor(color / 256) % 256
  local b = color % 256
  local tr = math.floor(target / 65536) % 256
  local tg = math.floor(target / 256) % 256
  local tb = target % 256
  r = math.floor(r + (tr - r) * amount)
  g = math.floor(g + (tg - g) * amount)
  b = math.floor(b + (tb - b) * amount)
  return r * 65536 + g * 256 + b
end

-- perceived brightness, 0 (black) to 1 (white). read from the actual Normal
-- background rather than vim.o.background, which some themes leave stale when
-- you switch away from a light colorscheme.
local function luminance(color)
  local r = math.floor(color / 65536) % 256
  local g = math.floor(color / 256) % 256
  local b = color % 256
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255
end

local function update_dim_highlights()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if not normal.bg then
    return
  end
  local target = luminance(normal.bg) > 0.5 and BLACK or WHITE
  local wash_bg = blend(normal.bg, target, WASH_AMOUNT)
  local wash_fg = normal.fg and blend(normal.fg, target, WASH_AMOUNT) or nil
  vim.api.nvim_set_hl(0, "NormalNC", { fg = wash_fg, bg = wash_bg })
  vim.api.nvim_set_hl(0, "StatusLineNC", { fg = wash_fg, bg = wash_bg })
  vim.api.nvim_set_hl(0, "SignColumnNC", { fg = wash_fg, bg = wash_bg })
  vim.api.nvim_set_hl(0, "EndOfBufferNC", { fg = wash_bg, bg = wash_bg })
end

update_dim_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = update_dim_highlights })

local winhl = "SignColumn:SignColumnNC,EndOfBuffer:EndOfBufferNC"

local function is_normal_window(win)
  return vim.api.nvim_win_get_config(win).relative == ""
end

local group = vim.api.nvim_create_augroup("DimInactiveWindows", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  group = group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if is_normal_window(win) then
      vim.wo[win].winhighlight = ""
    end
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = group,
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if is_normal_window(win) then
      vim.wo[win].winhighlight = winhl
    end
  end,
})
