-- formatting and syntax highlighting
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" } }, { confirm = false })

local ts_parsers = {
  "lua", "c", "rust", "go",
  "vim", "vimdoc", "query",
  "markdown", "markdown_inline",
  "typescript", "tsx", "javascript",
  "html", "css", "json", "yaml", "toml",
}

local nts = require("nvim-treesitter")
nts.install(ts_parsers)

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function()
    nts.update()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang and vim.treesitter.language.add(lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start(args.buf)
    end
  end,
})
