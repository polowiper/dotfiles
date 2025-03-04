{pkgs, ...}:

{ 
 programs.vscode = {
  enable = true;
  package = pkgs.vscodium;
  extensions = with pkgs.vscode-extensions; [
    catppuccin.catppuccin-vsc
    vscode-icons-team.vscode-icons
    ms-toolsai.jupyter
    bbenoist.nix
    ocamllabs.ocaml-platform
    yzhang.markdown-all-in-one
    ms-vsliveshare.vsliveshare
    arjun.swagger-viewer
    mhutchie.git-graph
    eamodio.gitlens
    adpyke.codesnap
  ];
 };
}
