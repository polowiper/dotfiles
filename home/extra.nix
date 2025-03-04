{pkgs, inputs, ...}: 

let
  nix-alien-pkgs = inputs.nix-alien.packages.${pkgs.system};
in
  { 
 home.packages = with pkgs; [
  vial
  obs-studio
  xorg.xev
  telegram-desktop

  scrcpy
  android-tools
  apktool
  ghex
  httptoolkit-server
  httptoolkit
  deluge
  graphviz
  rpi-imager
  sqlitestudio

  texlive.combined.scheme-basic
  texstudio

  mullvad-vpn
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
