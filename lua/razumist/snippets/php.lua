require("luasnip.session.snippet_collection").clear_snippets("php")
local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("php", {
	s("hi", fmt("privet {} pidoras {}", { i(1), i(0) })),
	s("dst", fmt("declare(strict_types=1);", {})),
	s(
		"sfc",
		fmt(
			[[<?php
declare(strict_types=1);

class {} {{{}}}
        ]],
			{ f(function()
				return vim.fn.expand("%:t:r")
			end), i(0) }
		)
	),
	s(
		"sfi",
		fmt(
			[[<?php

interface {} {{{}}}
        ]],
			{ f(function()
				return vim.fn.expand("%:t:r")
			end), i(0) }
		)
	),
	s(
		"pubf",
		fmt("public function {}({}):{} {{{}}}", {
			i(1),
			i(2),
			i(3, "void"),
			i(0),
		})
	),
	s(
		"prvf",
		fmt("private function {}({}):{} {{{}}}", {
			i(1),
			i(2),
			i(3, "void"),
			i(0),
		})
	),
	s(
		"cnst",
		fmt("public function __construct({}) {{{}}}", {
			i(1),
			i(0),
		})
	),
})
