local M = {}

local function whole_document_params(bufnr, kind)
  return {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ["end"] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
    },
    context = {
      diagnostics = {},
      only = { kind },
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    },
  }
end

local function apply_action(client, bufnr, action, done)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end

  if action.command then
    local command = type(action.command) == "table" and action.command or action
    -- vtsls appends this private telemetry command after its workspace edit,
    -- but does not advertise it to generic LSP clients such as Neovim.
    if command.command ~= "_typescript.didOrganizeImports" then
      client:exec_cmd(command, {
        bufnr = bufnr,
        client_id = client.id,
        method = "textDocument/codeAction",
      })
    end
  end

  done(true)
end

local function resolve_and_apply(client, bufnr, action, done)
  if action.disabled then
    vim.notify(action.disabled.reason, vim.log.levels.WARN)
    done(false)
    return
  end

  if (action.edit or action.command) or not client:supports_method("codeAction/resolve") then
    apply_action(client, bufnr, action, done)
    return
  end

  client:request("codeAction/resolve", action, function(err, resolved)
    if err then
      vim.notify(string.format("%s could not resolve import action: %s", client.name, err.message), vim.log.levels.ERROR)
      done(false)
      return
    end

    apply_action(client, bufnr, resolved or action, done)
  end, bufnr)
end

local function run(candidates, opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local index = 0
  local found_client = false

  local function try_next()
    index = index + 1
    local candidate = candidates[index]
    if not candidate then
      if opts.callback then opts.callback(false) end
      if not opts.silent then
        local message = found_client and ("No changes available for " .. opts.label)
          or ("No attached language server supports " .. opts.label)
        vim.notify(message, vim.log.levels.INFO)
      end
      return
    end

    local client
    for _, attached in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })) do
      if attached.name == candidate.client then
        client = attached
        break
      end
    end

    if not client then
      try_next()
      return
    end
    found_client = true

    client:request("textDocument/codeAction", whole_document_params(bufnr, candidate.kind), function(err, actions)
      if err then
        vim.notify(string.format("%s import action failed: %s", client.name, err.message), vim.log.levels.ERROR)
        try_next()
        return
      end

      local action
      for _, item in ipairs(actions or {}) do
        if item.kind == candidate.kind then
          action = item
          break
        end
      end

      if not action then
        try_next()
        return
      end

      resolve_and_apply(client, bufnr, action, function(applied)
        if opts.callback then opts.callback(applied) end
      end)
    end, bufnr)
  end

  try_next()
end

function M.add_missing_imports(bufnr, opts)
  opts = vim.tbl_extend("force", opts or {}, { bufnr = bufnr, label = "adding missing imports" })
  run({ { client = "vtsls", kind = "source.addMissingImports.ts" } }, opts)
end

function M.organize_imports(bufnr, opts)
  opts = vim.tbl_extend("force", opts or {}, { bufnr = bufnr, label = "organizing imports" })
  run({
    { client = "biome", kind = "source.organizeImports.biome" },
    { client = "vtsls", kind = "source.organizeImports" },
  }, opts)
end

function M.remove_unused_imports(bufnr, opts)
  opts = vim.tbl_extend("force", opts or {}, { bufnr = bufnr, label = "removing unused imports" })
  run({ { client = "vtsls", kind = "source.removeUnusedImports" } }, opts)
end

function M.clean_imports(bufnr, opts)
  opts = vim.tbl_extend("force", opts or {}, { bufnr = bufnr, label = "cleaning imports" })
  run({
    -- TypeScript's "All" mode removes unused imports and sorts the rest in
    -- one workspace edit, avoiding stale ranges between chained LSP actions.
    { client = "vtsls", kind = "source.organizeImports" },
    { client = "biome", kind = "source.organizeImports.biome" },
  }, opts)
end

return M
