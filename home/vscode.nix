{pkgs, ...}:

{ 
 programs.vscode = {
  enable = true;
  package = pkgs.vscodium;
  extensions = with pkgs.vscode-extensions; [
    catppuccin.catppuccin-vsc
    vscode-icons-team.vscode-icons
    ms-toolsai.jupyter
    ms-python.python
    bbenoist.nix
    ocamllabs.ocaml-platform
    yzhang.markdown-all-in-one
  ];
 };
}
