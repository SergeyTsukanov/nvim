return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/lua/razumist/snippets" } })
		local types = require("luasnip.util.types")

		luasnip.config.set_config({
			-- This tells LuaSnip to remember to keep around the last snippet.
			-- You can jump back into it even if you move outside of the selection
			history = false,

			-- This one is cool cause if you have dynamic snippets, it updates as you type!
			updateevents = "TextChanged,TextChangedI",

			-- Autosnippets:
			enable_autosnippets = true,

			-- Crazy highlights!!
			-- #vid3
			-- ext_opts = nil,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { " « ", "NonTest" } },
					},
				},
			},
		})

		vim.keymap.set({ "i" }, "<C-x>", function()
			luasnip.expand()
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-l>", function()
			luasnip.jump(1)
		end, { silent = true })
		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			luasnip.jump(-1)
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-E>", function()
			if luasnip.choice_active() then
				luasnip.change_choice(1)
			end
		end, { silent = true })

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						-- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
						cmp.select_next_item()
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- this way you will only jump inside the snippet region
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-e>"] = cmp.mapping({
					i = function()
						if cmp.visible() then
							cmp.abort()
						else
							cmp.complete()
						end
					end,
					c = function()
						if cmp.visible() then
							cmp.close()
						else
							cmp.complete()
						end
					end,
				}),
			}),
			sources = {
				{ name = 'supermaven' },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
			},
		})
	end,
}
