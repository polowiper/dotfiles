return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }
    dashboard.section.buttons.val = {
      dashboard.button("p", "  Find project", ":Telescope projects <CR>"),
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "󰱼  Find file", ":Telescope find_files <CR>"),
      dashboard.button("t", "󰺮  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("m", "  BookMarks", ":Telescope marks <CR>"),
      dashboard.button("e", "  Extensions ", ":Lazy<CR>"),
      dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
      dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
    }

    dashboard.section.footer.val = {
      "",
      "Utiliser emacs c'est vraiment chaud nofake - Confucius",
      "",
    }
    alpha.setup(dashboard.opts)
  end,
}
