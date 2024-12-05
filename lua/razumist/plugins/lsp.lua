return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},

	config = function()
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }
				-- set keybinds
				opts.desc = "Show LSP references"
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
				end
				map("[d", vim.diagnostic.goto_prev, "Go to previous [D]iagnostic message")
				map("]d", vim.diagnostic.goto_next, "Go to next [D]iagnostic message")
				map("<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
			end,
		})
		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["angularls"] = function()
				local ok, mason_registry = pcall(require, "mason-registry")
				if not ok then
					vim.notify("mason-registry could not be loaded")
					return
				end
				local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

				local util = require("lspconfig.util")
				local cmd = {
					"ngserver",
					"--stdio",
					"--tsProbeLocations",
					table.concat({
						angularls_path,
						vim.uv.cwd(),
					}, ","),
					"--ngProbeLocations",
					table.concat({
						angularls_path .. "/node_modules/@angular/language-server",
						vim.uv.cwd(),
					}, ","),
				}
				lspconfig["angularls"].setup({
					capabilities = capabilities,
					cmd = cmd,
					root_dir = util.root_pattern("angular.json", "project.json"),
					on_new_config = function(new_config, new_root_dir)
						new_config.cmd = cmd
					end,
				})
			end,
			["phpactor"] = function()
				lspconfig["phpactor"].setup({
					capabilities = capabilities,
					filetypes = { "php" },

					init_options = {
						-- ["language_server.diagnostics_on_update"] = true,
						-- ["language_server.diagnostics_on_open"] = true,
						-- ["language_server.diagnostics_on_save"] = true,
						["language_server_phpstan.enabled"] = false,
						["language_server_psalm.enabled"] = false,
					},
				})
			end,
			-- ["intelephense"] = function()
			-- 	lspconfig["intelephense"].setup({ capabilities = capabilities, settings = {
			-- 		intelephense = { telemetry = false },
			-- 	} })
			-- end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
	end,
}
