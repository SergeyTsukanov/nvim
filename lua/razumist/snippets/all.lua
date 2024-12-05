
require("luasnip.session.snippet_collection").clear_snippets("all")
local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("all", {
	s("pp", fmt("privet {} pidoras {}", { i(1), i(0) })),
})

