# General-purpose development tooling. Project-specific toolchains live in
# per-project devshells; Neovim, VS Code, opencode/pi and Android are modules.
{pkgs, ...}: {
  home.packages = with pkgs; [
    python311
    python311Packages.dbus-python
    libgcc
    gnumake
    lazygit
    sqlite
    quarto
    texliveSmall
  ];
}
