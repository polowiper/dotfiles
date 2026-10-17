return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 200,
  },
  keys = {
    {
      "<leader>w",
      function()
        require("which-key").show({ global = true, showlocalleader = true, })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

