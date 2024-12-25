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
      settings.flavour = "mocha";
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

    alpha = let
        nixFlake = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
      in {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 4;
          }
          {
            opts = {
              hl = "AlphaHeader";
              position = "center";
            };  
            type = "text";
            val = nixFlake;
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = let
              mkButton = shortcut: cmd: val: hl: {
                type = "button";
                inherit val;
                opts = {
                  inherit hl shortcut;
                  keymap = [
                    "n"
                    shortcut
                    cmd
                    {}
                  ];
                  position = "center";
                  cursor = 0;
                  width = 40;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              };
            in [
              (
                mkButton
                "n"
                "<CMD>ene<CR>"
                "󱇧 New file"
                "Operator"
              )
              (
                mkButton
                "f"
                "<CMD>lua require('telescope.builtin').find_files({hidden = true})<CR>"
                "🔍 Find File"
                "Operator"
              )
              (
                mkButton
                "q"
                "<CMD>qa<CR>"
                "💣 Quit Neovim"
                "String"
              )
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            opts = {
              hl = "GruvboxBlue";
              position = "center";
            };
            type = "text";
            val = "";
          }
        ];
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

    conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          formatters_by_ft = {
            python = ["black"];
            nix = ["alejandra"];
            markdown = [["prettierd" "prettier"]];
            ocaml = ["ocamlformat" "ocp-Indent"];
          };
        };
    };
    web-devicons = {
      enable = true;
    };
    fidget = {
        enable = true;
        logger = {
          level = "warn"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
          floatPrecision = 0.01; # Limit the number of decimals displayed for floats
        };
        progress = {
          pollRate = 0; # How and when to poll for progress messages
          suppressOnInsert = true; # Suppress new messages while in insert mode
          ignoreDoneAlready = false; # Ignore new tasks that are already complete
          ignoreEmptyMessage = false; # Ignore new tasks that don't contain a message
          clearOnDetach =
            # Clear notification group when LSP server detaches
            ''
              function(client_id)
                local client = vim.lsp.get_client_by_id(client_id)
                return client and client.name or nil
              end
            '';
          notificationGroup =
            # How to get a progress message's notification group key
            ''
              function(msg) return msg.lsp_client.name end
            '';
          ignore = []; # List of LSP servers to ignore
          lsp.progressRingbufSize = 0; # Configure the nvim's LSP progress ring buffer size
          display = {
            renderLimit = 16; # How many LSP messages to show at once
            doneTtl = 3; # How long a message should persist after completion
            doneIcon = "✔"; # Icon shown when all LSP progress tasks are complete
            doneStyle = "Constant"; # Highlight group for completed LSP tasks
            progressTtl = "math.huge"; # How long a message should persist when in progress
            progressIcon = {
            pattern = "dots";
            period = 1;
            }; # Icon shown when LSP progress tasks are in progress
            progressStyle = "WarningMsg"; # Highlight group for in-progress LSP tasks
            groupStyle = "Title"; # Highlight group for group name (LSP server name)
            iconStyle = "Question"; # Highlight group for group icons
            priority = 30; # Ordering priority for LSP notification group
            skipHistory = true; # Whether progress notifications should be omitted from history
            formatMessage = ''
              require ("fidget.progress.display").default_format_message
            ''; # How to format a progress message
            formatAnnote = ''
              function (msg) return msg.title end
            ''; # How to format a progress annotation
            formatGroupName = ''
              function (group) return tostring (group) end
            ''; # How to format a progress notification group's name
          };
        };
        notification = {
          pollRate = 10; # How frequently to update and render notifications
          filter = "info"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
          historySize = 128; # Number of removed messages to retain in history
          overrideVimNotify = true;
          redirect = ''
            function(msg, level, opts)
              if opts and opts.on_open then
                return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
              end
            end
          '';
          configs = {
            default = "require('fidget.notification').default_config";
          };

          window = {
            normalHl = "Comment";
            winblend = 0;
            border = "none"; # none, single, double, rounded, solid, shadow
            zindex = 45;
            maxWidth = 0;
            maxHeight = 0;
            xPadding = 1;
            yPadding = 0;
            align = "bottom";
            relative = "editor";
          };
          view = {
            stackUpwards = true; # Display notification items from bottom to top
            iconSeparator = " "; # Separator between group name and icon
            groupSeparator = "---"; # Separator between notification groups
            groupSeparatorHl = "Comment"; # Highlight group used for group separator
          };
        };
      };

    noice = {
        enable = true;
        settings = {
          notify.enabled = false;
          messages.enabled = true; # Adds a padding-bottom to neovim statusline when set to false for some reason

          lsp = {
            message.enabled = true;
            progress = {
              enabled = false;
              view = "mini";
            };
        };
        popupmenu = {
          enabled = true;
          backend = "nui";
        };
        format = {
        filter = {
          pattern = [":%s*%%s*s:%s*" ":%s*%%s*s!%s*" ":%s*%%s*s/%s*" "%s*s:%s*" ":%s*s!%s*" ":%s*s/%s*"];
          icon = "";
          lang = "regex";
        };
        replace = {
          pattern = [":%s*%%s*s:%w*:%s*" ":%s*%%s*s!%w*!%s*" ":%s*%%s*s/%w*/%s*" "%s*s:%w*:%s*" ":%s*s!%w*!%s*" ":%s*s/%w*/%s*"];
          icon = "󱞪";
          lang = "regex";
            };
          };
        };
      };


    notify = {
        enable = true;
        backgroundColour = "#000000";
        fps = 60;
        render = "default";
        timeout = 1000;
        topDown = true;
    };

    treesitter = {
        enable = true;
        settings.indent.enable = true;
        folding = true;
        nixvimInjections = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
          nix
          markdown
          markdown_inline
          python
          c 
          ocaml
        ];
      };
    treesitter-context.enable = true;

    treesitter-textobjects = {
        enable = false;
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ii" = "@conditional.inner";
            "ai" = "@conditional.outer";
            "il" = "@loop.inner";
            "al" = "@loop.outer";
            "at" = "@comment.outer";
          };
        };
        move = {
          enable = true;
          gotoNextStart = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          gotoNextEnd = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
          gotoPreviousStart = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          gotoPreviousEnd = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swapNext = {"<leader>a" = "@parameters.inner";};
          swapPrevious = {"<leader>A" = "@parameter.outer";};
        };
      };
      

      lualine = {
        enable = true;
        settings.options = {
          theme = "modus-vivendi";
          globalstatus = true;
          component_separators = { 
            right = "";
            left = "";
          };
        };
      };
      bufferline = {
        enable = true;
        settings.options = {
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
      };
      nvim-autopairs = {
        enable = true;
        settings.check_ts = true;
      };

      auto-save = {
        enable = true;
      };

      flash = {
        enable = true;
        settings = {
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
      nix = {
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
        settings = {
          default_mappings = true;
        };
      };

      which-key = {
        enable = true;
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
          #ocamllsp.enable = true;
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
      };
      

    extraPlugins = with pkgs; [
      vimPlugins.supermaven-nvim
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

    keymaps = [
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

    #Notify 
     {
      mode = "n";
      key = "<leader>un";
      action = ''
        <cmd>lua require("notify").dismiss({ silent = true, pending = true })<cr>
      '';

      options.desc = "Dismiss All Notifications";
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
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
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
      local notify = require("notify")

    local filtered_message = { "No information available" }

    -- Override notify function to filter out messages
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(message, level, opts)
    	local merged_opts = vim.tbl_extend("force", {
    		on_open = function(win)
    			local buf = vim.api.nvim_win_get_buf(win)
    			vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    		end,
    	}, opts or {})

    	for _, msg in ipairs(filtered_message) do
    		if message == msg then
    			return
    		end
    	end
    	return notify(message, level, merged_opts)
    end
    '';
  };
}
