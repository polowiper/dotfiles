{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      github.copilot-chat
      github.copilot

      vscode-icons-team.vscode-icons
      ms-toolsai.jupyter
      bbenoist.nix
      ocamllabs.ocaml-platform
      yzhang.markdown-all-in-one
      ms-vsliveshare.vsliveshare
      ms-vscode.cpptools-extension-pack
      ms-vscode.cpptools
      arjun.swagger-viewer
      platformio.platformio-vscode-ide
      mhutchie.git-graph
      eamodio.gitlens
      adpyke.codesnap
    ];
  };
}
