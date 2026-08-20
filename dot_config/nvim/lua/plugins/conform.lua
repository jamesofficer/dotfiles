-- formatting
vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
}, { confirm = false })

local util = require("conform.util")

local biome_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
  json = true,
  jsonc = true,
  css = true,
  scss = true,
  html = true,
}

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("/node_modules/") then return end

    return {
      timeout_ms = 1000,
      lsp_format = biome_filetypes[ft] and "never" or "fallback",
    }
  end,
  formatters = {
    biome = {
      cwd = util.root_file({
        "biome.json",
        "biome.jsonc",
        "pnpm-workspace.yaml",
        ".git",
      }),
      require_cwd = true,
    },
    ["biome-organize-imports"] = {
      cwd = util.root_file({
        "biome.json",
        "biome.jsonc",
        "pnpm-workspace.yaml",
        ".git",
      }),
      require_cwd = true,
    },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "biome-organize-imports", "biome" },
    javascriptreact = { "biome-organize-imports", "biome" },
    typescript = { "biome-organize-imports", "biome" },
    typescriptreact = { "biome-organize-imports", "biome" },
    json = { "biome" },
    jsonc = { "biome" },
    css = { "biome" },
    scss = { "biome" },
    html = { "biome" },
  },
})

vim.api.nvim_create_user_command("OrganizeImports", function()
  require("import_actions").organize_imports(0)
end, {})
