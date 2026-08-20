-- lsp server installation and configuration

-- lsp servers we want to use and their configuration
-- see `:h lspconfig-all` for available servers and their settings
local lsp_servers = {
  biome = {},
  vtsls = {},
  lua_ls = {
    -- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
    Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) }, },
  },
}

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig", -- default configs for lsps

  -- NOTE: if you'd rather install the lsps through your OS package manager you
  -- can delete the next three mason-related lines and their setup calls below.
  -- see `:h lsp-quickstart` for more details.
  "https://github.com/mason-org/mason.nvim",                     -- package manager
  "https://github.com/mason-org/mason-lspconfig.nvim",           -- lspconfig bridge
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" -- auto installer
}, { confirm = false })

require("mason").setup()
-- automatic_enable is off so the lsp_servers table above is the only thing
-- that decides which servers actually start
require("mason-lspconfig").setup({ automatic_enable = false })
require("mason-tool-installer").setup({
  ensure_installed = vim.tbl_keys(lsp_servers),
})

local function peek_definition()
  local params = vim.lsp.util.make_position_params(0, "utf-8")

  vim.lsp.buf_request_all(0, "textDocument/definition", params, function(results)
    local locations = {}
    local seen = {}

    for client_id, response in pairs(results) do
      local result = response.result
      if result and not vim.tbl_isempty(result) then
        local client = vim.lsp.get_client_by_id(client_id)
        local offset_encoding = client and client.offset_encoding or "utf-8"

        for _, location in ipairs(vim.islist(result) and result or { result }) do
          local uri = location.uri or location.targetUri
          local range = location.range or location.targetSelectionRange or location.targetRange

          if uri and range then
            local key = table.concat({
              uri,
              range.start.line,
              range.start.character,
              range["end"].line,
              range["end"].character,
            }, ":")

            if not seen[key] then
              seen[key] = true
              table.insert(locations, { location = location, offset_encoding = offset_encoding })
            end
          end
        end
      end
    end

    if #locations == 0 then
      vim.notify("No definition found", vim.log.levels.INFO)
      return
    end

    vim.lsp.util.preview_location(locations[1].location, { border = "rounded" }, { offset_encoding = locations[1].offset_encoding })
  end)
end

local function rename_symbol()
  local current = vim.fn.expand("<cword>")
  if current == "" then
    vim.notify("No symbol under cursor", vim.log.levels.WARN)
    return
  end
  vim.ui.input({ prompt = "Rename: ", default = current }, function(new_name)
    if not new_name or new_name == "" or new_name == current then return end

    local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/rename" })
    if #clients == 0 then
      vim.notify("No LSP client supports rename", vim.log.levels.WARN)
      return
    end

    local total_files = {}
    local pending = #clients

    for _, client in ipairs(clients) do
      local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
      params.newName = new_name
      client:request("textDocument/rename", params, function(err, result)
        pending = pending - 1
        if err then
          vim.notify("Rename error from " .. client.name .. ": " .. err.message, vim.log.levels.ERROR)
        elseif result then
          vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
          for uri in pairs(result.changes or {}) do total_files[uri] = true end
          for _, doc in ipairs(result.documentChanges or {}) do
            if doc.textDocument and doc.textDocument.uri then total_files[doc.textDocument.uri] = true end
          end
        end
        if pending == 0 then
          vim.cmd("silent! noautocmd wall")
          local count = vim.tbl_count(total_files)
          vim.notify(string.format("Renamed '%s' → '%s' across %d file(s)", current, new_name, count))
        end
      end, 0)
    end
  end)
end

local import_actions = require("import_actions")

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
local ok_blink, blink = pcall(require, "blink.cmp")
local lsp_capabilities = ok_blink and blink.get_lsp_capabilities() or nil

for server, config in pairs(lsp_servers) do
  vim.lsp.config(server, {
    settings = config,
    capabilities = lsp_capabilities,

    -- only create the keymaps if the server attaches successfully
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
        { buffer = bufnr, desc = "Code action", })

      vim.keymap.set("n", "<leader>cf", function()
        require("conform").format({ bufnr = bufnr, async = true, lsp_format = "fallback" })
      end, { buffer = bufnr, desc = "Format buffer", })

      vim.keymap.set("n", "<leader>cp", peek_definition,
        { buffer = bufnr, desc = "Peek definition", })

      vim.keymap.set("n", "<leader>cr", rename_symbol,
        { buffer = bufnr, desc = "Rename symbol", })

      vim.keymap.set("n", "<leader>ci", function() import_actions.add_missing_imports(bufnr) end,
        { buffer = bufnr, desc = "Import missing imports", })

      vim.keymap.set("n", "<leader>co", function() import_actions.clean_imports(bufnr) end,
        { buffer = bufnr, desc = "Clean and organize imports", })

      vim.keymap.set("n", "<leader>cx", function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
        vim.lsp.codelens.run()
      end, { buffer = bufnr, desc = "Run codelens", })

      vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float,
        { buffer = bufnr, desc = "Line [d]iagnostics float", })

      vim.keymap.set("n", "<leader>cD", vim.diagnostic.setqflist,
        { buffer = bufnr, desc = "All [D]iagnostics quickfix", })
    end,
  })

  vim.lsp.enable(server)
end
