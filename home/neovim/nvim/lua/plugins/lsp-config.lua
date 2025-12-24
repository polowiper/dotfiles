-- LSP config (safe: won't call setup on missing servers)
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
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

				-- Attach nvim-navic if present and server supports documentSymbolProvider
				if client.server_capabilities and client.server_capabilities.documentSymbolProvider then
					local ok_navic, navic = pcall(require, "nvim-navic")
					if ok_navic and navic then
						navic.attach(client, bufnr)
					end
				end
			end

			-- Servers: adjust names here as needed for the language servers you install via Nix
			local servers = {
				clangd = {},
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true) },
							telemetry = { enable = false },
						},
					},
				},
				asm_lsp = {},
				ocamllsp = {},
				pylsp = {}, -- you have python-lsp-server in Nix
				ts_ls = {}, -- use ts_ls (tsserver is deprecated in lspconfig)
				nixd = {}, -- keep nixd here if that's the server you installed; change to "rnix" if you use rnix-lsp
				texlab = {
					settings = {
						texlab = {
							build = {
								executable = "latexmk",
								args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-shell-escape", "%f" },
								onSave = true,
							},
							chktex = { onOpenAndSave = true },
							forwardSearch = { executable = "", args = {} },
							diagnostics = { delay = 300 },
						},
					},
				},
			}

			-- require lspconfig once (fail early if missing)
			local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
			if not lspconfig_ok then
				vim.notify("lspconfig not available", vim.log.levels.ERROR)
				return
			end

			-- Optional: debug helper to list available servers from lspconfig
			-- Uncomment to inspect what lspconfig currently exposes (useful for server-name mismatches)
			--[[
      do
        local available = {}
        for k,v in pairs(lspconfig) do
          if type(v) == "table" and type(v.setup) == "function" then
            table.insert(available, k)
          end
        end
        table.sort(available)
        vim.notify("lspconfig servers: " .. table.concat(available, ", "))
      end
      --]]

			-- Setup each server only if lspconfig exposes it and it has a setup() function
			for name, opts in pairs(servers) do
				opts = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, opts or {})

				local srv = lspconfig[name]
				if srv and type(srv.setup) == "function" then
					srv.setup(opts)
				else
					-- Friendly warning so you can map Nix packages -> lspconfig names
					vim.notify(
						("lspconfig: server '%s' not found or has no setup(); check installed server name"):format(name),
						vim.log.levels.WARN
					)
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
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
		end,
	},
}
