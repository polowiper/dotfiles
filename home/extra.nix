{
  pkgs, ...}: 
{
 
 home.packages = with pkgs; [
  vial
  obs-studio
  xorg.xev
  telegram-desktop

  scrcpy
  android-tools
  ghidra
  mitmproxy
  mitmproxy2swagger
  apktool
  ghex
  qt5.full
  libsForQt5.full
  qtcreator
  graphviz
  google-chrome #I fucking hate this browser but it's the only one having webhid enabled
  sqlitestudio

  blender
  texlive.combined.scheme-basic
  texstudio

  galculator
  kdePackages.okular
  lorien
  bitwarden-desktop
  temurin-bin
  prismlauncher
  nemo
  loupe
  grim
  swappy
  slurp
  mpv-unwrapped
  nix-inspect
  nix-prefetch-scripts
  anydesk
  ];
}
