return {
	"L3MON4D3/LuaSnip",
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")

		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node

		ls.add_snippets("javascript", {
			s("loggy", {
				t("console.log("),
				i(1),
				t(");"),
				i(0),
			}),
		})
	end,
}
