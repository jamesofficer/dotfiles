-- better statusline
vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" }, { confirm = false })

require("lualine").setup({
  options = {
    section_separators = { left = "", right = "", },
    component_separators = { left = "", right = "", },
  },
  sections = {
    lualine_c = {
      { "filename", path = 1 }, -- 0 = name, 1 = relative, 2 = absolute, 3 = absolute ~, 4 = name + parent
    },
    lualine_x = {
      {
        function()
          local reg = vim.fn.reg_recording()
          if reg == "" then return "" end
          return "recording @" .. reg
        end,
        color = "DiagnosticWarn",
      },
      "encoding",
      "fileformat",
      "filetype",
    },
  },
})
