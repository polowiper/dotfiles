return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"latex",
				"markdown",
				"markdown_inline",
				"nix",
				"ocaml",
				"python",
			},
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<Enter>", -- set to `false` to disable one of the mappings
					node_incremental = "<Enter>",
					scope_incremental = false,
					node_decremental = "<Backspace>",
				},
			},
		})

		-- Fix for Nvim 0.12 + some injection queries (otter/quarto):
		-- nvim-treesitter's directive handlers can receive a list of nodes when
		-- queries are iterated with `{ all = true }`. Neovim core expects a TSNode.
		-- If the handler passes the list to `vim.treesitter.get_node_text`, Neovim
		-- will try to call `node:range()` and error.
		pcall(function()
			require("nvim-treesitter.query_predicates")
			local query = vim.treesitter.query
			local ts = vim.treesitter

			local html_script_type_languages = {
				importmap = "json",
				module = "javascript",
				["application/ecmascript"] = "javascript",
				["text/ecmascript"] = "javascript",
			}

			local non_filetype_match_injection_language_aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				uxn = "uxntal",
				ts = "typescript",
			}

			local function get_parser_from_markdown_info_string(injection_alias)
				local match = vim.filetype.match({ filename = "a." .. injection_alias })
				return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
			end

			local function first_node(x)
				if type(x) == "table" then
					return x[1]
				end
				return x
			end

			query.add_directive(
				"set-lang-from-mimetype!",
				function(match, _, bufnr, pred, metadata)
					local capture_id = pred[2]
					local node = first_node(match[capture_id])
					if not node then
						return
					end
					local type_attr_value = ts.get_node_text(node, bufnr)
					local configured = html_script_type_languages[type_attr_value]
					if configured then
						metadata["injection.language"] = configured
					else
						local parts = vim.split(type_attr_value, "/", {})
						metadata["injection.language"] = parts[#parts]
					end
				end,
				{ force = true, all = true }
			)

			query.add_directive(
				"set-lang-from-info-string!",
				function(match, _, bufnr, pred, metadata)
					local capture_id = pred[2]
					local node = first_node(match[capture_id])
					if not node then
						return
					end
					local injection_alias = ts.get_node_text(node, bufnr):lower()
					metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
				end,
				{ force = true, all = true }
			)

			query.add_directive(
				"downcase!",
				function(match, _, bufnr, pred, metadata)
					local id = pred[2]
					local node = first_node(match[id])
					if not node then
						return
					end
					local text = ts.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
					metadata[id] = metadata[id] or {}
					metadata[id].text = string.lower(text)
				end,
				{ force = true, all = true }
			)
		end)
	end,
}
