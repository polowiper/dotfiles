return {
  "benlubas/molten-nvim",
  build = ":UpdateRemotePlugins",     -- required for molten
  config = function()
    -- ⬇️ Your full plugin config goes below this line:

    -- only do this if you're on Linux and xdg-open is problematic
    -- if vim.fn.has("unix") == 1 and vim.fn.hostname() ~= "Darwin" then
    --   vim.g.molten_open_cmd = "firefox"
    -- end

    vim.g.molten_auto_open_output = true
    vim.g.molten_image_location = "float"
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_border = { "", "━", "", "" }
    vim.g.molten_output_win_max_height = 12
    vim.g.molten_virt_text_output = true
    vim.g.molten_use_border_highlights = true
    vim.g.molten_virt_lines_off_by_1 = true
    vim.g.molten_wrap_output = true
    vim.g.molten_tick_rate = 142
    vim.keymap.set({ "v", "n" }, "<leader><leader>R", "<Cmd>MoltenEvaluateVisual<CR>")
    vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten", silent = true })
    vim.keymap.set("n", "<localleader>ip", function()
      local venv = os.getenv("VIRTUAL_ENV")
      if venv ~= nil then
        venv = string.match(venv, "/.+/(.+)")
        vim.cmd(("MoltenInit %s"):format(venv))
      else
        vim.cmd("MoltenInit python3")
      end
    end, { desc = "Initialize Molten for python3", silent = true, noremap = true })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MoltenInitPost",
      callback = function()
        local r = require("quarto.runner")
        vim.keymap.set("n", "<localleader>rc", r.run_cell, { desc = "run cell", silent = true })
        vim.keymap.set("n", "<localleader>ra", r.run_above, { desc = "run cell and above", silent = true })
        vim.keymap.set("n", "<localleader>rb", r.run_below, { desc = "run cell and below", silent = true })
        vim.keymap.set("n", "<localleader>rl", r.run_line, { desc = "run line", silent = true })
        vim.keymap.set("n", "<localleader>rA", r.run_all, { desc = "run all cells", silent = true })
        vim.keymap.set("n", "<localleader>RA", function()
          r.run_all(true)
        end, { desc = "run all cells of all languages", silent = true })

        vim.keymap.set("n", "<localleader>e", ":MoltenEvaluateOperator<CR>", { desc = "evaluate operator", silent = true })
        vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
        vim.keymap.set("v", "<localleader>r", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "execute visual selection", silent = true })
        vim.keymap.set("n", "<localleader>os", ":noautocmd MoltenEnterOutput<CR>", { desc = "open output window", silent = true })
        vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
        vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })

        local open = false
        vim.keymap.set("n", "<localleader>ot", function()
          open = not open
          vim.fn.MoltenUpdateOption("auto_open_output", open)
        end)

        if vim.bo.filetype == "python" then
          vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
          vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.py",
      callback = function(e)
        if string.match(e.file, ".otter.") then return end
        if require("molten.status").initialized() == "Molten" then
          vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
          vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = { "*.qmd", "*.md", "*.ipynb" },
      callback = function()
        if require("molten.status").initialized() == "Molten" then
          vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", true)
          vim.fn.MoltenUpdateOption("molten_virt_text_output", true)
        end
      end,
    })

    local function import_metadata_based_kernel(e)
      vim.schedule(function()
        local kernels = vim.fn.MoltenAvailableKernels()
        local try_kernel_name = function()
          local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
          return metadata.kernelspec.name
        end
        local ok, kernel_name = pcall(try_kernel_name)

        if not ok or not vim.tbl_contains(kernels, kernel_name) then
          kernel_name = nil
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            kernel_name = string.match(venv, "/.+/(.+)")
          end
        end

        if kernel_name and vim.tbl_contains(kernels, kernel_name) then
          vim.cmd(("MoltenInit %s"):format(kernel_name))
        end
        vim.cmd("MoltenImportOutput")
      end)
    end

    vim.api.nvim_create_autocmd("BufAdd", {
      pattern = { "*.ipynb" },
      callback = import_metadata_based_kernel,
    })

    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.ipynb" },
      callback = function()
        if require("molten.status").initialized() == "Molten" then
          vim.cmd("MoltenExportOutput!")
        end
      end,
    })

    local default_notebook = [[
      {
        "cells": [
         {
          "cell_type": "markdown",
          "metadata": {},
          "source": [
            ""
          ]
         }
        ],
        "metadata": {
         "kernelspec": {
          "display_name": "Python 3",
          "language": "python",
          "name": "python3"
         },
         "language_info": {
          "codemirror_mode": {
            "name": "ipython"
          },
          "file_extension": ".py",
          "mimetype": "text/x-python",
          "name": "python",
          "nbconvert_exporter": "python",
          "pygments_lexer": "ipython3"
         }
        },
        "nbformat": 4,
        "nbformat_minor": 5
      }
    ]]

    local function new_notebook(filename)
      local path = filename .. ".ipynb"
      local file = io.open(path, "w")
      if file then
        file:write(default_notebook)
        file:close()
        vim.cmd("edit " .. path)
      else
        print("Error: Could not open new notebook file for writing.")
      end
    end

    vim.api.nvim_create_user_command('NewNotebook', function(opts)
      new_notebook(opts.args)
    end, {
      nargs = 1,
      complete = 'file'
    })

    -- ⬆️ End of your config
  end,
}
