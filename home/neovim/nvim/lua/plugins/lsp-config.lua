return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local servers = {
				clangd = {},
				lua_ls = {},
				ocamllsp = {},
				pylsp = {},
				ts_ls = {},
				nixd = {},
				texlab = {},
			}
			for server, opts in pairs(servers) do
				opts.capabilities = capabilities
				opts.on_attach = function(client, bufnr)
					require("nvim-navic").attach(client, bufnr)
				end
				require("lspconfig")[server].setup(opts)
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
}
