return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snak = require("snacks")
    snak.setup({
    
        indent = {
          enabled = false,
            -- char = "", -- "¦"
          scope = {
            enabled = false,
          },
          animate = {
            enabled = false,
            duration = {
              step = 10,
            },
          },
          chunk = {
            enabled = false,
            corner_top = "╭",
            corner_bottom = "╰",
          },
        },
      
        explorer = {
          enabled = true,
          replace_netrw = true,
        },
      
        statuscolumn = {
          enabled = false,
        },
      
        terminal = {
          enabled = true,
        },
      
        toggle = {
          enabled = true,
        },
      
        picker = {
          enabled = true,
        },
      
        scratch = {
          enabled = true,
        },
      })
    
      -- SCRATCH --------------------------------------------
      vim.keymap.set("n", "<leader>.",  function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
      vim.keymap.set("n", "<leader>S",  function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
    
    
      -- TERMINAL -------------------------------------------
      vim.keymap.set("n", "<c-;>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
    
    
      -- TOGGLE ---------------------------------------------
      Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>ur")
      Snacks.toggle.option("number", { name = "Number" }):map("<leader>un")
      Snacks.toggle.option("hlsearch", { name = "Highlight search" }):map("<leader>uH")
      Snacks.toggle.option("cursorline", { name = "Cursor line" }):map("<leader>uc")
      Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uz")
    
      -- -- Mini
      -- Snacks.toggle.option("minidiff_disable", { name = "Mini diff"}):map("<leader>uf")
      -- Snacks.toggle.option("minipairs_disable", { name = "Mini pairs"}):map("<leader>up")
    
      Snacks.toggle.diagnostics():map("<leader>ud")
      Snacks.toggle.line_number():map("<leader>ul")
      Snacks.toggle.treesitter():map("<leader>uT")
      Snacks.toggle.inlay_hints():map("<leader>uh")
      Snacks.toggle.indent():map("<leader>ug")
      Snacks.toggle.dim():map("<leader>uD")
    
    
      -- PICKER ---------------------------------------------
      vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
      vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
      vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
      vim.keymap.set("n", "<leader>a", function() Snacks.explorer() end, { desc = "File Explorer", })
    
      -- find
      vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
      vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
      vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
    
      -- git
      vim.keymap.set("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Git Log" })
      vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
    
      -- Grep
      vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
      vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
      vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
      vim.keymap.set({ "n", "x"}, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })
    
      -- search
      vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
      vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
      vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
      vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
      vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
      vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
      vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
      vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
      vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
      vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
      vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
      vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
      vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
      vim.keymap.set("n", "<leader>qp", function() Snacks.picker.projects() end, { desc = "Projects" })
    
      -- LSP
      vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
      vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { nowait = true, desc = "References" })
      vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
      vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
      vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
    end,
}