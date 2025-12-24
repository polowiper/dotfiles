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
      arjun.swagger-viewer
      mhutchie.git-graph
      eamodio.gitlens
      adpyke.codesnap
      lucianIrsigler.nasm
      13
      xforever.language-x86-64-assembly
    ];
  };
}
