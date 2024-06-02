{pkgs, ...}: 
{
 
 home.packages = with pkgs; [
  python311
  python311Packages.numpy
  python311Packages.matplotlib
  ocaml
  ocamlPackages.utop
  gcc
  vial
  obs-studio
  xorg.xev
  osu-lazer-bin
  telegram-desktop
  scrcpy
  android-tools
  gnome.nautilus
  nautilus-open-any-terminal
  loupe
  grim
  swappy
  slurp
  mpv-unwrapped
  nix-inspect
  nix-prefetch-scripts
  ];
}
