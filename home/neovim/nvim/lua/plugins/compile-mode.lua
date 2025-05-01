return {
  "ej-shafran/compile-mode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "m00qek/baleia.nvim",
  },
  config = function()
    ---@type CompileModeOpts
    vim.g.compile_mode = {
      -- to add ANSI escape code support, add:
      baleia_setup = true,
      default_command = "make",
      vim.keymap.set("n", "<leader>cc", ":Compile<CR>", { desc = "Compiles the code", silent = true }),
      vim.keymap.set("n", "<leader>cr", ":Recompile<CR>", { desc = "Recompiles the code", silent = true }),
      -- to make `:Compile` replace special characters (e.g. `%`) in
      -- the command (and behave more like `:!`), add:
      -- bang_expansion = true,
    }
  end,
}
