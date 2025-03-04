require("blink.cmp").setup({
    enabled = function()
      return not vim.tbl_contains({ }, vim.bo.filetype)
      and vim.bo.buftype ~= "prompt"
      and vim.b.completion ~= false
    end,
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = 'super-tab'
    },
  
    completion = {
      keyword = { range = "full" },
      list = {
        max_items = 20,
      },
      menu = {
        draw = {
          treesitter = { 'lsp' },
        },
        border = "single",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 400,
        window = { border = "single", },
      },
    };
  
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },
  
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        buffer = {
          opts = {
            -- or (recommended) filter to only "normal" buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ''
              end, vim.api.nvim_list_bufs())
            end
          },
        },
      },
    },
  })