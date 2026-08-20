-- blink.cmp completion
vim.pack.add({
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
}, { confirm = false })

-- rebuild rust binary after blink.cmp update (manual cargo build via shell)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(args)
    if args.data and args.data.spec and args.data.spec.name == "blink.cmp" then
      vim.schedule(function()
        vim.notify("Rebuilding blink.cmp rust binary...", vim.log.levels.INFO)
        local repo = vim.fn.stdpath("data") .. "/site/pack/core/opt/blink.cmp"
        local hash = vim.fn.system({ "git", "-C", repo, "rev-parse", "HEAD" }):sub(1, 7)
        local dest = vim.fn.stdpath("data") .. "/site/lib"
        vim.fn.mkdir(dest, "p")
        vim.fn.system({ "cargo", "build", "--release", "--manifest-path", repo .. "/Cargo.toml" })
        vim.fn.system({ "cp", repo .. "/target/release/libblink_cmp_fuzzy.dylib", dest ..
        "/libblink_cmp_fuzzy.dylib." .. hash })
        vim.notify("blink.cmp rebuild complete (restart nvim)", vim.log.levels.INFO)
      end)
    end
  end,
})

-- disable native completion (blink replaces it)
vim.o.autocomplete = false

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<C-f>"] = { "show", "show_documentation", "hide_documentation" },
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    accept = { auto_brackets = { enabled = false } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = false },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
