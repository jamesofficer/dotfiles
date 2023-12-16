vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitbelow = true -- open window below rather than above
vim.opt.splitright = true -- open new splits to the right
vim.opt.wrap = false -- disables line wrapping
vim.opt.expandtab = true -- converts tabs to spaes
vim.opt.tabstop = 4 -- make tab 4 spaces instead of 8
vim.opt.shiftwidth = 4 -- match indent hotkey with tabstop setting
vim.opt.clipboard = "unnamedplus" -- sync vim and system clipboard
vim.opt.scrolloff = 999 -- scroll off the end of the page
vim.opt.virtualedit = "block" -- when in visual block mode, allow the cursor to extend past the last char
vim.opt.inccommand = "split" -- preview commands such as find and replace in a new split
vim.opt.ignorecase = true -- dont require uppercase when searching for plugin commands
vim.opt.termguicolors = true -- use full color palette, 24bit colors
vim.o.hlsearch = false -- turn off search highlighting
vim.o.mouse = 'a' -- enable mouse mode
vim.o.breakindent = true -- break indent
vim.o.undofile = true -- save undo history
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true -- (same as above)
vim.wo.signcolumn = 'yes' -- keep sign column by default
vim.o.updatetime = 250 -- decrease update time
vim.o.timeoutlen = 300 -- (same as above)

-- ========= CUSTOM AUTOCOMMANDS ========= --
-- [[ Highlight on yank ]] -- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

