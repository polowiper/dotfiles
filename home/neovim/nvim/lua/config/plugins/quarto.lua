local quarto = require("quarto")

quarto.setup({
  lspFeatures = {
    languages = { "python", "rust", "lua" },
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

vim.keymap.set("n", "<localleader>qp", quarto.quartoPreview,
  { desc = "Preview the Quarto document", silent = true, noremap = true })

vim.keymap.set("n", "<localleader>cc", "i```{}\r\r```",
  { desc = "Create a new code cell", silent = true })

vim.keymap.set("n", "<localleader>cs", "i```\r\r```{}<left>",
  { desc = "Split code cell", silent = true, noremap = true })


