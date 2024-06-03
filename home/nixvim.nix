{pkgs, inputs, ...}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
    };

    globals.mapleader = " ";
#/----------------------------------------\
#|            __            _             |
#|     ____  / /_  ______ _(_)___  _____  |
#|    / __ \/ / / / / __ `/ / __ \/ ___/  |
#|   / /_/ / / /_/ / /_/ / / / / (__  )   |
#|  / .___/_/\__,_/\__, /_/_/ /_/____/    | 
#| /_/            /____/                  |
#\----------------------------------------/
      plugins = {
    nvim-tree = {
      enable = true;
    };

    telescope = {
        enable = true;
        highlightTheme = "catppuccin-mocha";
        extensions = {
          file-browser.enable = true;
          fzf-native.enable = true;
        };
        settings.defaults = {
          layout_config.horizontal.prompt_position = "top";
          sorting_strategy = "ascending";
        };
      };

      lualine = {
        enable = true;
        theme = "modus-vivendi";
        globalstatus = true;
        componentSeparators = { 
          right = "";
          left = "";
        };
      };
      bufferline = {
        enable = true;
        alwaysShowBufferline = false;
        diagnostics = "nvim_lsp";
        numbers = "buffer_id";
        offsets = [
          {
            filetype = "NvimTree";
            text = "File Explorer";
            text_align = "left";
            separator = false;
          }
        ];
        showBufferCloseIcons = false;
        showCloseIcon = false;
        indicator.style = null;
      };

      nvim-autopairs = {
        enable = true;
        checkTs = true;
      };

      auto-save = {
        enable = true;
      };

      flash = {
        enable = true;
        labels = "asdfghjklqwertyuiopzxcvbnm";
        search = {
          mode = "fuzzy";
        };
        jump = {
          autojump = true;
        };
        label = {
          uppercase = false;
          rainbow = {
            enabled = false;
            shade = 5;
          };
        };
      };

      oil = {
        enable = true;
        settings  = {
          useDefaultKeymaps = true;
          deleteToTrash = true;
          float = {
            padding = 2;
            maxWidth = 0; # ''math.ceil(vim.o.lines * 0.8 - 4)'';
            maxHeight = 0; # ''math.ceil(vim.o.columns * 0.8)'';
            border = "rounded"; # 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
            winOptions = {
              winblend = 0;
            };
          };
          preview = {
            border = "rounded";
          };
          keymaps = {
            "g?" = "actions.show_help";
            "<CR>" = "actions.select";
            "<C-\\>" = "actions.select_vsplit";
            "<C-enter>" = "actions.select_split"; # this is used to navigate left
            "<C-t>" = "actions.select_tab";
            "<C-v>" = "actions.preview";
            "<C-c>" = "actions.close";
            "<C-r>" = "actions.refresh";
            "-" = "actions.parent";
            "_" = "actions.open_cwd";
            "`" = "actions.cd";
            "~" = "actions.tcd";
            "gs" = "actions.change_sort";
            "gx" = "actions.open_external";
            "g." = "actions.toggle_hidden";
            "q" = "actions.close";
          };
        };
      };

      toggleterm = {
        enable = true;
      };

      molten = {
        enable = true;
        settings = {
          auto_image_popup = true;
        };
      };

      leap = {
        enable = true;
      };

      indent-blankline = {
        enable = true;
        settings = {
          exclude = {
            buftypes = [
              "terminal"
              "quickfix"
            ];
            filetypes = [
              ""
              "checkhealth"
              "help"
              "lspinfo"
              "TelescopePrompt"
              "TelescopeResults"
              "yaml"
            ];
          };
          indent.char = "│"; #  `▎`,`│`
          scope.enabled = false;
        };
      };

      undotree = {
        enable = true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
      };

      better-escape = {
        enable = true;
        mapping = [ "jj" "jk" ];
      };

      which-key = {
        enable = true;
        operators = {
          gc = "Comments";
        };
      };

      
      treesitter = {
        enable = true;
        # folding = true;
        indent = true;
        incrementalSelection = {
          enable = true;
        };
      };

      illuminate = {
        enable = true;
        underCursor = false;
        filetypesDenylist = [
          "Outline"
          "TelescopePrompt"
          "alpha"
          "harpoon"
          "reason"
        ];
      };

      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          clangd.enable = true;
          ocamllsp.enable = true;
          nixd.enable = true;
        };
        keymaps = {
          #diagnostic = {
          #  "<leader>j" = "goto_next";
          #  "<leader>k" = "goto_prev";
          #};
          #silent = true;
          #lspBuf = {
          #  K = "hover";
          #  gD = "references";
          #  gd = "definition";
          #  gi = "implementation";
          #  gt = "type_definition";
          #};
        };
      };

      cmp = 
      let
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      in
        {
        enable = true;
        cmdline = {
          "/" = {
            mapping = mapping;
            sources = [
              { name = "buffer"; }
            ];
          };
          ":" = {
            mapping = mapping;
            sources = [
              { name = "path"; }
              {
                name = "cmdline";
                option = {
                  ignore_cmds = [
                    "Man"
                    "!"
                  ];
                };
              }
            ];
          };
        };
        settings = {
          mapping = mapping;
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          performance.max_view_entries = 10;
        };
      };
    };
    

    extraPlugins = with pkgs; [
      vimPlugins.iron-nvim
      vimPlugins.comment-nvim
      vimPlugins.neoscroll-nvim
 ];

#/------------------------------------------------\
#|      __                                        |
#|     / /_____  __  ______ ___  ____ _____  _____|
#|    / //_/ _ \/ / / / __ `__ \/ __ `/ __ \/ ___/|
#|   / ,< /  __/ /_/ / / / / / / /_/ / /_/ (__  ) |
#|  /_/|_|\___/\__, /_/ /_/ /_/\__,_/ .___/____/  |
#|            /____/               /_/            |
#\------------------------------------------------/

    keymaps = 
    let 
      def = {
      mode = ["n" "v"];
      options.silent = true;
    }; 
    in [
      # Nvim Tree
    {
      key = "<leader>e";
      action = "<cmd>:NvimTreeFocus<CR>";
      options.desc = "Nvim Tree Focus";
    }

    # Telescope 
    {
      mode = "n";
      key = "<leader><space>";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find files";
    }
 
    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Telescope live_grep";
    }

    {
      mode = "n";
      key = "<leader>:";
      action = "<cmd>Telescope command_history<cr>";
      options.desc = "Commands history";
    }

    {
      mode = "n";
      key = "<leader>b";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "Navigate through your buffers";
    }

    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options.desc = "Find files w/ Telescope (again?!?!??!)";
    }

    {
      mode = "n";
      key = "<leader>fr";
      action = "<cmd>Telescope live_grep<cr>";
      options.desc = "Telescope live_grep";
    }

    {
      mode = "n";
      key = "<leader>fR";
      action = "<cmd>Telescope resume<cr>";
      options.desc = "Resume Telescope";
    }

    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope oldfiles<cr>";
      options.desc = "Find smth through your old files";
    }

    {
      mode = "n";
      key = "<leader>b";
      action = "<cmd>Telescope buffers<cr>";
      options.desc = "Telescope through your buffers";
    }

    {
      mode = "n";
      key = "<C-p>";
      action = "<cmd>Telescope git_files<cr>";
      options.desc = "Telescope through your git files";
    }

    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>Telescope git_commits<cr>";
      options.desc = "Search in your commits";
    }

    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope git_status<cr>";
      options.desc = "Telescope the git status";
    }

    {
      mode = "n";
      key = "<leader>sa";
      action = "<cmd>Telescope autocommands<cr>";
      options.desc = "Find certain commands";
    }

    {
      mode = "n";
      key = "<leader>sb";
      action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
      options.desc = "Telescope into your current buffer";
    }

    {
      mode = "n";
      key = "<leader>sc";
      action = "<cmd>Telescope command_history<cr>";
      options.desc = "Shows your commands history";
    }

    {
      mode = "n";
      key = "<leader>sC";
      action = "<cmd>Telescope commands<cr>";
      options.desc = "Shows the commands";
    }

    {
      mode = "n";
      key = "<leader>sh";
      action = "<cmd>Telescope help_tags<cr>";
      options.desc = "Basically a --help";
    }

    {
      mode = "n";
      key = "<leader>sH";
      action = "<cmd>Telescope highlights<cr>";
      options.desc = "Shows the synthax highlighting";
    }

    {
      mode = "n";
      key = "<leader>sk";
      action = "<cmd>Telescope keymaps<cr>";
      options.desc = "Shows all of your keymaps";
    }

    {
      mode = "n";
      key = "<leader>sm";
      action = "<cmd>Telescope man_pages<cr>";
      options.desc = "Shows the different man pages";
    }

    {
      mode = "n";
      key = "<leader>sM";
      action = "<cmd>Telescope marks<cr>";
      options.desc = "Lists vim marks and their value";
    }

    {
      mode = "n";
      key = "<leader>so";
      action = "<cmd>Telescope vim_options<cr>";
      options.desc = "Shows the different vim options";
    }

    {
      mode = "n";
      key = "<leader>sR";
      action = "<cmd>Telescope resume<cr>";
      options.desc = "Resumes Telescope";
    }

    {
      mode = "n";
      key = "<leader>uC";
      action = "<cmd>Telescope colorscheme<cr>";
      options.desc = "Shows the different colorschemes";
    }

    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options.desc = "Document diagnostics";
    }
    {
      mode = "n";
      key = "<leader>fe";
      action = "<cmd>Telescope file_browser<cr>";
      options.desc = "File browser";
    }
    {
      mode = "n";
      key = "<leader>fE";
      action = "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>";
      options.desc = "File browser";
    }

    #ToggleTerm
    {
      key = "<leader>v";
      action = "<cmd>:ToggleTerm size=40 direction=vertical<CR>";
      options.desc = "Toggle a vertical terminal";
    }

    # Oil 
     {
      mode = "n";
      key = "-";
      action = ":Oil<CR>";
      options = {
        desc = "Open parent directory";
        silent = true;
      };
    }

    # Flash shit
    {
      mode = ["n" "x" "o"];
      key = "s";
      action = "<cmd>lua require('flash').jump()<cr>";
      options = {
        desc = "Flash";
      };
    }

    {
      mode = ["n" "x" "o"];
      key = "S";
      action = "<cmd>lua require('flash').treesitter()<cr>";
      options = {
        desc = "Flash Treesitter";
      };
    }

    {
      mode = "o";
      key = "r";
      action = "<cmd>lua require('flash').remote()<cr>";
      options = {
        desc = "Remote Flash";
      };
    }

    {
      mode = ["x" "o"];
      key = "R";
      action = "<cmd>lua require('flash').treesitter_search()<cr>";
      options = {
        desc = "Treesitter Search";
      };
    }


    # SnipRun
    {
      key = "<leader>ss";
      action = "<cmd>:SnipRun<CR>";
      options.desc = "Snip Run";
    }
    {
      key = "<leader>sr";
      action = "<cmd>:SnipReset<CR>";
      options.desc = "Snip Reset";
    }
    {
      key = "<leader>sq";
      action = "<cmd>:SniClose<CR>";
      options.desc = "Snip Close";
    }

    # Undo Tree
    {
      mode = "n";
      key = "<leader>ut";
      action = "<cmd>UndotreeToggle<CR>";
      options = {
        silent = true;
        desc = "Undotree";
      };
    }

    # Resize with arrows
    {
      key = "<C-Up>";
      action = ":resize -2<CR>";
      options.desc =  "Resize Up";
    }
    {
      key = "<C-Down>";
      action = ":resize +2<CR>";
      options.desc =  "Resize Down";
    }
    {
      key = "<C-Left>";
      action = ":vertical resize -2<CR>";
      options.desc =  "Resize Left";
    }
    {
      key = "<C-Right>";
      action = ":vertical resize +2<CR>";
      options.desc =  "Resize Right";
    }

    # Navigate BUffers
    {
      key = "<tab>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Buffer Cycle Next";
    }
    {
      key = "<S-tab>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Buffer Cycle Previous";
    }
    {
      key = "<leader>q";
      action = "<cmd>bp<bar>sp<bar>bn<bar>bd<CR>";
      options.desc = "Buffer Close";
    } 
    ];

#/---------------------------------------\
#|                __  _                  |   
#|   ____  ____  / /_(_)___  ____  _____ |   
#|  / __ \/ __ \/ __/ / __ \/ __ \/ ___/ |   
#| / /_/ / /_/ / /_/ / /_/ / / / (__  )  |   
#| \____/ .___/\__/_/\____/_/ /_/____/   |   
#|     /_/                               |
#\---------------------------------------/

    opts = {

      # STARTUP
      swapfile = false;
      undofile = true;

      # QOL
      clipboard.providers.wl-copy.enable = true;
      ignorecase = true;
      showmode = false;
      termguicolors = true;
      timeoutlen = 300;
      updatetime = 250;
      mouse = "a"; 

      # INDENT
      smartindent = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;

      # NAVIGATION
      cursorline = true;
      number = true;
      relativenumber = true;
      numberwidth = 2;
      signcolumn = "yes";
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      splitbelow = true;
      splitright = true;
    };

    extraConfigLua = ''
      vim.opt.shortmess:append "IcA"
      vim.opt.whichwrap:append("<,>,h,l,[,]") 
      require('Comment').setup()
          require('neoscroll').setup {}
      require("telescope").setup{
      pickers = {
        colorscheme = {
          enable_preview = true
        }
      }
    }
      local view = require("iron.view")
      require("iron.core").setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            ml = {
              command = {"utop"}
            },
            py = {
              command = {"python"}
            },
          },
          repl_open_cmd = view.split.vertical.botright(80)
        },
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = {
          italic = true
        },
        ignore_blank_lines = true,
      })
    '';
  };
}
