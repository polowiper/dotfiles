return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.ocamlformat,
        null_ls.builtins.formatting.alejandra,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.yapf,

        null_ls.builtins.hover.dictionary,
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {desc="Formats your code"})
  end,
}
