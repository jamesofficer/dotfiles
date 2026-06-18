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

local function organize_imports(bufnr)
  bufnr = bufnr or 0
  local biome_client
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.name == "biome" then
      biome_client = client
      break
    end
  end
  if not biome_client then return end

  local kind = "source.organizeImports.biome"
  local params = vim.lsp.util.make_range_params(0, biome_client.offset_encoding)
  params.context = { only = { kind }, diagnostics = {} }

  biome_client:request("textDocument/codeAction", params, function(_, result)
    for _, action in ipairs(result or {}) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, biome_client.offset_encoding)
      elseif action.data then
        biome_client:request("codeAction/resolve", action, function(_, resolved)
          if resolved and resolved.edit then
            vim.lsp.util.apply_workspace_edit(resolved.edit, biome_client.offset_encoding)
          end
        end, bufnr)
      end
    end
  end, bufnr)
end

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if bufname:match("/node_modules/") then return end

    pcall(function() organize_imports(bufnr) end)

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
  },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    jsonc = { "biome" },
    css = { "biome" },
    scss = { "biome" },
    html = { "biome" },
  },
})

vim.api.nvim_create_user_command("OrganizeImports", function() organize_imports(0) end, {})
