return {
  "GCBallesteros/jupytext.nvim",
  config = function()
	-- jupytext.nvim still uses the deprecated table-form `vim.validate{...}`.
	-- Wrap `vim.validate` so table-calls are forwarded to the new varargs API.
	local _validate = vim.validate
	vim.validate = function(...)
		local first = select(1, ...)
		if select('#', ...) == 1 and type(first) == 'table' then
			for name, spec in pairs(first) do
				-- Spec is { value, type, optional? }
				_validate(name, spec[1], spec[2], spec[3])
			end
			return
		end
		return _validate(...)
	end

 local jupytext = require("jupytext")
 jupytext.setup({
   jupytext = 'jupytext',
   format = "markdown",

  update = true,
  filetype = require("jupytext").get_filetype,
  custom_language_formatting = {
    python = {
      extension = "qmd",
      style = "quarto",
      force_ft = "quarto", -- you can set whatever filetype you want here
    },
  },
  --new_template = require("jupytext").default_new_template(),
  sync_patterns = { '*.md', '*.py', '*.jl', '*.R', '*.Rmd', '*.qmd' },
  autosync = true,
  handle_url_schemes = true,

 })

	-- Restore the original once setup is done.
	vim.validate = _validate
 end,
}
