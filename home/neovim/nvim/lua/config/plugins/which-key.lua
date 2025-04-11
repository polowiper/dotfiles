-- Which-key setup
require("which-key").setup({
  delay = 200,
})

-- Function to show both global and localleader keymaps
vim.keymap.set("n", "<leader>w", function()
  require("which-key").show({
    global = true,           -- Show global keymaps (i.e., <leader> keymaps)
    show_localleader = true, -- Show localleader keymaps
  })

end, { desc = "Show Buffer Local and Global Keymaps (which-key)" })
