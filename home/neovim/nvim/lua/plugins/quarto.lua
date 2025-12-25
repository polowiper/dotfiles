return {
	"quarto-dev/quarto-nvim",
	dependencies = {
		"jmbuhr/otter.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local quarto = require("quarto")

		quarto.setup({
			lspFeatures = {
				-- include LaTeX so quarto-nvim will try to provide features for latex blocks
				languages = { "python", "rust", "lua", "latex" },
				chunks = "all", -- 'curly' or 'all'
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			keymap = {
				hover = "H",
				definition = "gd",
				rename = "<leader>rn",
				references = "gr",
				format = "<leader>gf",
			},
			codeRunner = {
				enabled = true,
				ft_runners = {
					bash = "slime",
					python = "molten",
				},
				default_method = "molten",
			},
		})

		-- Preview (the existing helper)
		vim.keymap.set(
			"n",
			"<localleader>qp",
			quarto.quartoPreview,
			{ desc = "Preview the Quarto document", silent = true, noremap = true }
		)

		-- Create new code cell
		vim.keymap.set("n", "<localleader>cc", "i```{}\r\r```", { desc = "Create a new code cell", silent = true })

		-- Split code cell
		vim.keymap.set(
			"n",
			"<localleader>cs",
			"i```\r\r```{}<left>",
			{ desc = "Split code cell", silent = true, noremap = true }
		)

		-- Async render to PDF: <localleader>qP
		vim.keymap.set("n", "<localleader>qP", function()
			local file = vim.api.nvim_buf_get_name(0)
			if file == "" then
				vim.notify("No file in buffer", vim.log.levels.WARN)
				return
			end
			vim.notify("Rendering PDF: " .. file)
			-- Run quarto render <file> --to pdf asynchronously
			vim.fn.jobstart({ "quarto", "render", file, "--to", "pdf" }, {
				stdout_buffered = true,
				stderr_buffered = true,
				on_stdout = function(_, data)
					if data and #data > 0 then
						-- show some output in notifications (could be extended to a floating window)
						vim.notify(table.concat(data, "\n"))
					end
				end,
				on_stderr = function(_, data)
					if data and #data > 0 then
						vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR)
					end
				end,
				on_exit = function(_, code)
					if code == 0 then
						vim.notify("Quarto render finished (pdf)", vim.log.levels.INFO)
					else
						vim.notify("Quarto render failed with exit code: " .. tostring(code), vim.log.levels.ERROR)
					end
				end,
			})
		end, { desc = "Render current Quarto document to PDF", silent = true })
	end,
}
