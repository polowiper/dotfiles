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

    #ToggleTerm
    {
      key = "<leader>v";
      action = "<cmd>:ToggleTerm size=40 direction=vertical<CR>";
      options.desc = "Toggle a vertical terminal";
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
