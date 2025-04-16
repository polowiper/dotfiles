{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      pkgs.tree-sitter-grammars.tree-sitter-norg-meta
      nvim-treesitter-parsers.norg
      image-nvim
      nvim-web-devicons
      mini-nvim
      snacks-nvim

      blink-cmp
      nvim-notify
      iron-nvim
      molten-nvim
      quarto-nvim
      otter-nvim
      jupytext-nvim
      bufferline-nvim
      flash-nvim
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      #C/C++
      gcc
      gnumake
      gdb
      cmake
      clang
      clang-tools

      #Python
      python3
      python312Packages.jupytext #You need to add it here instead of the extraPython3Packages because the extraPython3Packages won't append the executable to the PATH which makes jupytext unable to detect the jupytext executable basically making it not work
      pyright
      ruff

      #Ocaml
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat-rpc-lib
      ocamlPackages.ocamlformat
      ocamlPackages.utop

      #Lua
      lua-language-server

      #Nix
      nixd

      #Utils
      git
      curl
      fzf
      imagemagick
      vscode-langservers-extracted
    ];

    extraLuaPackages = luaPkgs:
      with luaPkgs; [
        magick # for image rendering
      ];

    extraPython3Packages = ps:
      with ps; [
        # MOLTEN
        pynvim
        jupyter-client
        cairosvg # for image rendering
        pnglatex # for image rendering
        plotly # for image rendering
        pyperclip
        nbformat

        # test molten
        ipython
        jupytext
        jupyter
        ipykernel
        numpy
        matplotlib
        scipy
      ];
  };

  home.file.".config/nvim" = {
    recursive = true;
    source = ./nvim;
  };
}
