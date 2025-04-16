local map = vim.keymap.set

-- NVChad-style on_attach
local function on_attach(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
end

-- Disable semanticTokens (NvChad-style)
local function on_init(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- Capabilities (NvChad-style, with cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- Merge with cmp capabilities if you use cmp
local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Your LSP servers config (unchanged but enhanced)
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "Snacks", "Mini", "MiniFiles" },
        },
        format = {
          preview = true,
        },
      },
    },
  },

  pyright = {
    on_attach = function(client, bufnr)
      -- your custom override + nvchad bindings
      on_attach(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, 'shiftwidth', 2)
      vim.api.nvim_buf_set_option(bufnr, 'tabstop', 2)
      vim.api.nvim_buf_set_option(bufnr, 'softtabstop', 2)
      vim.api.nvim_buf_set_option(bufnr, 'expandtab', true)
    end,
  },

  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  },

  ocamllsp = {
    cmd = { "ocamllsp" },
    filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
  },

  nixd = {
    cmd = { "nixd" },
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }",
        },
        formatting = {
          command = { "alejandra" },
        },
      },
    },
  },
}

-- Setup logic
local lspconfig = require "lspconfig"
for server, config in pairs(servers) do
  config.capabilities = config.capabilities or capabilities
  config.on_attach = config.on_attach or on_attach
  config.on_init = config.on_init or on_init
  lspconfig[server].setup(config)
end

