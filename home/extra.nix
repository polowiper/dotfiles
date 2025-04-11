{pkgs, inputs, ...}: 

let
  nix-alien-pkgs = inputs.nix-alien.packages.${pkgs.system};
in
 {
 home.packages = with pkgs; [
  vial
  obs-studio
  anki
  xorg.xev
  telegram-desktop

  bambu-studio #GOT A FUCKING 3D PRINTER LET'S GOOOOOOOOOOOOOO

  scrcpy
  android-tools
  apktool
  ghex
  ripgrep
  httptoolkit-server
  httptoolkit
  deluge
  graphviz
  rpi-imager
  sqlitestudio

  texlive.combined.scheme-basic
  texstudio
  sqlite

  quarto
  mullvad-vpn
  galculator
  kdePackages.okular
  lorien
  bitwarden-desktop
  temurin-bin
  prismlauncher
  planify
  loupe
  grim
  swappy
  wine-wayland
  slurp
  mpv-unwrapped
  nix-inspect
  nix-prefetch-scripts
  anydesk
] ++ [
  nix-alien-pkgs.nix-alien
];
}
