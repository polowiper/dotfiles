# TODO: Add a thing to highlish TODOs and also setup conform to autoformat on save and uhh some linter shit I guess although it's already half setup
{pkgs, ...}: let
  # Newer Rust rejects a glob-import ambiguity in veridian's vendored
  # `sv-parser-parser 0.8.3` (E0659). Patch the vendored crate to disambiguate
  # the import until upstream fixes it.
  veridian = pkgs.veridian.overrideAttrs (old: {
    cargoDeps = pkgs.runCommand "veridian-vendor-patched" {} (
      "cp -r ${old.cargoDeps} $out\n"
      + "chmod -R u+w $out\n"
      + "substituteInPlace $out/source-registry-0/sv-parser-parser-0.8.3/src/lib.rs "
      + "--replace-fail 'pub(crate) use sv_parser_syntaxtree::*;' "
      + "'pub(crate) use sv_parser_syntaxtree::*; pub(crate) use sv_parser_syntaxtree::VersionSpecifier;'\n"
    );
  });

  # Create a Python environment with all required packages for Molten/Neovim
  # We have it here and not in the extra py packages because we need some of those packages to be on the PATH
  python3WithPackages = pkgs.python3.withPackages (
    ps:
      with ps; [
        # MOLTEN / Neovim
        pynvim
        jupyter-client
        cairosvg
        pnglatex
        plotly
        pyperclip
        nbformat

        # Jupyter/IPython
        ipython
        jupytext
        jupyter
        ipykernel
        numpy
        matplotlib
        scipy
      ]
  );
in {
  nixpkgs.config.allowBroken = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;
    extraPython3Packages = ps:
      with ps; [
        pynvim
        jupyter-client
        nbformat
        ipykernel
      ];
    withNodeJs = true;
    withRuby = false; # Don't need that ?
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraPackages = with pkgs; [
      # Python with all required packages
      python3WithPackages
      #C/C++
      gcc
      gnumake
      gdb
      cmake
      clang
      clang-tools # Formatting

      #Vhdl + Verilog
      vhdl-ls
      veridian

      #Assembly
      asm-lsp
      asmfmt
      asmjit
      asmrepl

      #Python
      # python3 is now included via python3WithPackages above
      black # Formatting
      pyright
      # python312Packages.python-lsp-server   #FUCK YOU !!! WHY THE FUCK WOULD AN LSP NEED FUCKING SCIPY AS A DEPENDENCY AND MOREOVER WHY THE FUCK WOULD YOU BOTH BUILD IT FROM SOURCE AND RUN THE WHOLE 8 THOUSANDS FUCKING TEST FUCKING END YOURSELF
      isort # Formatting

      #Ocaml
      ocamlPackages.ocaml-lsp
      ocamlPackages.ocamlformat-rpc-lib # Formatting
      ocamlPackages.ocamlformat # Formatting
      ocamlPackages.utop

      #Lua
      stylua # Formatting
      lua5_1
      lua-language-server
      lua51Packages.luarocks

      #Nix
      nixd
      nixfmt # Required formatting in order to contribute to nixpkgs
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

      #Java
      java-language-server

      #Utils
      codespell
      git
      curl
      fzf
      imagemagick # image.nvim
      vscode-langservers-extracted
      tree-sitter
    ];

    extraLuaPackages = luaPkgs:
      with luaPkgs; [
        magick # for image rendering (although might not be needed now)
        luarocks
      ];

    # Python packages are now managed via python3WithPackages above
  };

  home.file.".config/nvim" = {
    recursive = true;
    source = ./nvim;
  };
}
