return {
	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- disables inline suggestions
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			-- copilot-cmp currently calls `client.is_stopped()` (deprecated in Nvim 0.13).
			-- Provide a real field so the call doesn't hit the deprecated accessor.
			local function patch_client(client)
				if not client or client.name ~= "copilot" then
					return
				end
				-- Implement it directly to avoid deprecated accessor and any recursion.
				client.is_stopped = function()
					local ok, closing = pcall(function()
						return client.rpc and client.rpc.is_closing and client.rpc.is_closing()
					end)
					return (ok and closing) or client._is_stopping or false
				end
			end

			for _, client in ipairs(vim.lsp.get_clients({ name = "copilot" }) or {}) do
				patch_client(client)
			end
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					patch_client(client)
				end,
			})
			require("copilot_cmp").setup()
		end,
	},
	{
		"onsails/lspkind.nvim",
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			-- replace your cmp.setup({...}) with this block
			local lspkind = require("lspkind")
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			-- robust helper instead of cmp.get_context().has_words_before
			local function has_words_before()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				if col == 0 then
					return false
				end
				local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
				if not text then
					return false
				end
				local char_before = text:sub(col, col)
				return not char_before:match("%s")
			end

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				confirm_opts = {
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				},

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = {
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if entry then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						elseif luasnip.expandable() then
							luasnip.expand()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.locally_jumpable(1) then
							luasnip.jump(1)
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},

				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},

				sources = cmp.config.sources({
					{ name = "copilot", priority = 1100, max_item_count = 10, keyword_length = 2 },
					{ name = "nvim_lsp", priority = 1000, max_item_count = 20 },
					{ name = "luasnip", priority = 900, max_item_count = 5 },
					{ name = "render-markdown", priority = 800 },
					{ name = "path", priority = 700 },
				}, {
					{ name = "buffer", priority = 600, max_item_count = 5, keyword_length = 3 },
				}),

				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
						col_offset = -3,
						side_padding = 1,
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					},
				},

				experimental = {
					ghost_text = { hl_group = "Comment" },
				},
			})
		end,
	},
}
