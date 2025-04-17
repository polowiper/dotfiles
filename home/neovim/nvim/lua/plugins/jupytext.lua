return {
  "GCBallesteros/jupytext.nvim",
  config = function()
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
end,
}