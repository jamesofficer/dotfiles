local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

require("config/options")
require("config/keybinds")
require("config/functions")
require("lazy").setup("plugins")

-- local lspconfig = require("lspconfig")
--
-- local lsps = { "typescript-language-server", "copilot-language-server" }
--
-- for _, lsp in pairs(lsps) do
-- 	local setup = {}
-- 	lspconfig[lsp].setup(setup)
--
-- 	vim.lsp.enable(lsp)
-- 	vim.lsp.config(lsp, setup)
-- end

-- vim.lsp.enable("copilot-language-server")
-- vim.lsp.config("copilot-language-server", {
-- 	nes = {
-- 		enabled = true,
-- 	},
-- })
