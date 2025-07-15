return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "gb",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
  opts = {
    ui = {
      ---@type integer
      max_height = -1, -- -1 means dynamic height
      -- Where to place the ui window
      -- Can be any of "topleft", "bottomleft", "topright", "bottomright", "center", "cursor" (sets under the current cursor pos)
      ---@type "topleft"|"bottomleft"|"topright"|"bottomright"|"center"|"cursor"
      position = "topright",
      -- Override options passed to `nvim_open_win`
      -- Be careful with this as snipe will not validate
      -- anything you override here. See `:h nvim_open_win`
      -- for config options
      ---@type vim.api.keyset.win_config
      open_win_override = {
        -- title = "My Window Title",
        border = "rounded", -- use "rounded" for rounded border
      },

      -- Preselect the currently open buffer
      ---@type boolean
      preselect_current = false,

      -- Set a function to preselect the currently open buffer
      -- E.g, `preselect = require("snipe").preselect_by_classifier("#")` to
      -- preselect alternate buffer (see :h ls and look at the "Indicators")
      ---@type nil|fun(buffers: snipe.Buffer[]): number
      preselect = nil, -- function (bs: Buffer[] [see lua/snipe/buffer.lua]) -> int (index)

      -- Changes how the items are aligned: e.g. "<tag> foo    " vs "<tag>    foo"
      -- Can be "left", "right" or "file-first"
      -- NOTE: "file-first" puts the file name first and then the directory name
      ---@type "left"|"right"|"file-first"
      text_align = "left",

      -- Provide custom buffer list format
      -- Available options:
      --  "filename" - basename of the buffer
      --  "directory" - buffer parent directory path
      --  "icon" - icon for buffer filetype from "mini.icons" or "nvim-web-devicons"
      --  string - any string, will be inserted as is
      --  fun(buffer_object): string,string - function that takes snipe.Buffer object as an argument
      --    and returns a string to be inserted and optional highlight group name
      -- buffer_format = { "->", "icon", "filename", "", "directory", function(buf)
      --   if vim.fn.isdirectory(vim.api.nvim_buf_get_name(buf.id)) == 1 then
      --     return " ", "SnipeText"
      --   end
      -- end },
    },
    hints = {
      -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
      ---@type string
      dictionary = "sadflewcmpghio",
    },
    navigate = {
      -- When the list is too long it is split into pages
      -- `[next|prev]_page` options allow you to navigate
      -- this list
      next_page = "J",
      prev_page = "K",

      -- You can also just use normal navigation to go to the item you want
      -- this option just sets the keybind for selecting the item under the
      -- cursor
      under_cursor = "<cr>",

      -- In case you changed your mind, provide a keybind that lets you
      -- cancel the snipe and close the window.
      ---@type string|string[]
      cancel_snipe = "q",

      -- Close the buffer under the cursor
      -- Remove "j" and "k" from your dictionary to navigate easier to delete
      -- NOTE: Make sure you don't use the character below on your dictionary
      close_buffer = "D",

      -- Open buffer in vertical split
      open_vsplit = "V",

      -- Open buffer in split, based on `vim.opt.splitbelow`
      open_split = "H",

      -- Change tag manually
      change_tag = "C",
    },
    -- The default sort used for the buffers
    -- Can be any of:
    --  "last" - sort buffers by last accessed
    --  "default" - sort buffers by its number
    --  fun(bs:snipe.Buffer[]):snipe.Buffer[] - custom sort function, should accept a list of snipe.Buffer[] as an argument and return sorted list of snipe.Buffer[]
    sort = "last",
  },
}
