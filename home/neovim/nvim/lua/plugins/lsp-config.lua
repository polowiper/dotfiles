-- lsp config (using new vim.lsp.config API for nvim 0.11+)
return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- safe capabilities (don't hard-fail if cmp is not present)
			local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = {}
			if ok_cmp and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
				capabilities = cmp_nvim_lsp.default_capabilities()
			end

			-- on_attach sets buffer-local keymaps and attaches navic if available
			local function on_attach(client, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gk", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

				-- attach nvim-navic if present and server supports documentsymbolprovider
				if client.server_capabilities and client.server_capabilities.documentsymbolprovider then
					local ok_navic, navic = pcall(require, "nvim-navic")
					if ok_navic and navic then
						navic.attach(client, bufnr)
					end
				end
			end

			-- servers: adjust names here as needed for the language servers you install via nix
			local servers = {
				clangd = {},
				vhdl_ls = {},
				lua_ls = {
					settings = {
						lua = {
							runtime = { version = "luajit", path = vim.split(package.path, ";") },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				},
				ocamllsp = {},
				pylsp = {}, -- you have python-lsp-server in nix
				ts_ls = {}, -- use ts_ls (tsserver is deprecated in lspconfig)
				nixd = {}, -- keep nixd here if that's the server you installed; change to "rnix" if you use rnix-lsp
				texlab = {
					settings = {
						texlab = {
							build = {
								executable = "latexmk",
								args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-shell-escape", "%f" },
								onsave = true,
							},
							chktex = { onopenandsave = true },
							forwardsearch = { executable = "", args = {} },
							diagnostics = { delay = 300 },
						},
					},
				},
			}

			-- Setup each server using the new vim.lsp.config API
			for name, opts in pairs(servers) do
				-- Merge default options with server-specific options
				opts = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, opts or {})

				-- Use the new vim.lsp.config API
				local config_name = name
				local ok = pcall(function()
					vim.lsp.config(config_name, opts)
				end)

				if ok then
					-- Enable the config for appropriate filetypes
					-- The new API auto-detects filetypes, but you can be explicit if needed
					vim.api.nvim_create_autocmd("FileType", {
						pattern = "*",
						callback = function(args)
							-- vim.lsp.enable will start the server if applicable
							pcall(vim.lsp.enable, config_name)
						end,
					})
				else
					vim.notify(("Failed to configure LSP server '%s'"):format(name), vim.log.levels.warn)
				end
			end

			-- diagnostics defaults
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- nicer float handlers
			vim.lsp.handlers["textdocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textdocument/signaturehelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
		end,
	},
}
