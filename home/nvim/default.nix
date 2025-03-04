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
      iron-nvim
      molten-nvim
      flash-nvim
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      gcc
      cmake
      git
      curl
      fzf
      python3
      imagemagick

      ccls
      clang-tools
      lua-language-server
      pyright
      ruff
      ocamlPackages.lsp
      ocamlPackages.ocamlformat
      nixd
      vscode-langservers-extracted

      ocamlPackages.utop
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
        jupyter
        ipykernel
        numpy
        matplotlib
        scipy
      ];
  };

  home.file.".config/nvim" = {
    recursive = true;
    source = ./luafiles;
  };
}