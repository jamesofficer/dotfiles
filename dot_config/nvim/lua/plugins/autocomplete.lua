-- native completion (neovim 0.12+)
vim.o.completeopt = "menuone,fuzzy,popup,noinsert,noselect"
vim.o.autocomplete = true
vim.o.complete = "o,.,w,b,u"

-- kind highlighting for completion menu
local kind_hl = {
  Text          = "@string",
  Method        = "@function",
  Function      = "@function",
  Constructor   = "@constructor",
  Field         = "@variable.member",
  Variable      = "@variable",
  Class         = "@type",
  Interface     = "@type",
  Module        = "@module",
  Property      = "@property",
  Unit          = "@operator",
  Value         = "@constant",
  Enum          = "@type",
  Keyword       = "@keyword",
  Snippet       = "@string",
  Color         = "@string",
  File          = "@constant",
  Reference     = "@constant",
  Folder        = "@constant",
  EnumMember    = "@constant",
  Constant      = "@constant",
  Struct        = "@type",
  Event         = "@keyword",
  Operator      = "@operator",
  TypeParameter = "@variable.parameter",
}

-- manually trigger completion menu
vim.keymap.set("i", "<C-f>", function()
  vim.lsp.completion.get()
end, { desc = "Trigger completion" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user.lsp-completion", { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
        convert = function(item)
          local kind_name = vim.lsp.protocol.CompletionItemKind[item.kind]
          if kind_name and kind_hl[kind_name] then
            return { kind_hlgroup = kind_hl[kind_name] }
          end
          return {}
        end,
      })
    end
  end,
})
