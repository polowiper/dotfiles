-- Colorscheme will be handled by stylix
vim.g.mapleader = " "
vim.g.maplocalleader = "m"
require("config.options")
require("lazy").setup("plugins")
require("config.keymaps")
