# TODO: Add a thing to highlish TODOs and also setup conform to autoformat on save and uhh some linter shit I guess although it's already half setup
{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    withNodeJs = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraPackages = with pkgs; [
      #C/C++
      gcc
      gnumake
      gdb
      cmake
      clang
      clang-tools # Formatting

      #Assembly
      asm-lsp
      asmfmt
      asmjit
      asmrepl

      #Python
      python3
      python312Packages.pygments
      python312Packages.jupytext # You need to add it here instead of the extraPython3Packages because the extraPython3Packages won't append the executable to the PATH which makes jupytext unable to detect the jupytext executable basically making it not work
      black # Formatting
      pyright
      python312Packages.python-lsp-server
      isort # Formatting

      #Ocaml
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat-rpc-lib # Formatting
      ocamlPackages.ocamlformat # Formatting
      ocamlPackages.utop

      #Lua
      stylua # Formatting
      lua
      lua-language-server
      lua51Packages.luarocks

      #Nix
      nixd
      nixfmt-rfc-style # Required formatting in order to contribute to nixpkgs
      alejandra # Formatting

      #Ts/Js
      typescript
      typescript-language-server
      jsbeautifier
      deno

      #Latex
      latexrun
      texlab
      texliveMedium # Minimal install to have latexmk there is also miktex or something but that thing requires a manual setup which is annoying
      (texlive.withPackages (ps: [ps.minted]))
      zathura
      zathuraPkgs.zathura_pdf_poppler
      biber
      latex2html
      xdotool

      #Utils
      codespell
      git
      curl
      fzf
      imagemagick
      vscode-langservers-extracted
      tree-sitter
    ];

    extraLuaPackages = luaPkgs:
      with luaPkgs; [
        magick # for image rendering
        luarocks
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
