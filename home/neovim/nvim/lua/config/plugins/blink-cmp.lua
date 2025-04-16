local has_words_before = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match("%s") == nil
end

require("blink.cmp").setup({
  enabled = function()
    local disabled_filetypes = { "TelescopePrompt", "neo-tree", "notify" }
    return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      and vim.bo.buftype ~= "prompt"
      and vim.b.completion ~= false
  end,

  keymap = {
      preset = 'none',

      -- If completion hasn't been triggered yet, insert the first suggestion; if it has, cycle to the next suggestion.
      ['<Tab>'] = {
        function(cmp)
          if has_words_before() then
            return cmp.insert_next()
          end
        end,
        'fallback',
      },
      -- Navigate to the previous suggestion or cancel completion if currently on the first one.
      ['<S-Tab>'] = { 'insert_prev' },
    },

  completion = {
    keyword = { range = "full" },
    list = {
      selection = { preselect = false },
      cycle = { from_top = false },
      max_items = 20,
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
      border = "single",
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 400,
      window = { border = "single" },
    },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },

  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      buffer = {
        opts = {
          get_bufnrs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.bo[bufnr].buftype == ""
            end, vim.api.nvim_list_bufs())
          end,
        },
      },
    },
  },
})

