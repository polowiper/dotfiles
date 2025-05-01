require("catppuccin").setup({
  transparent_background = true,
})
vim.cmd.colorscheme("catppuccin")
vim.g.mapleader = " "
vim.g.maplocalleader = "m"
require("config.options")
require("lazy").setup("plugins")
require("config.keymaps")
