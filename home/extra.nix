{pkgs, inputs, ...}: 
{
 
 home.packages = with pkgs; [
  vial
  obs-studio
  xorg.xev
  osu-lazer-bin
  telegram-desktop
  scrcpy
  android-tools
  gnome.nautilus
  loupe
  mpv-unwrapped
  nix-inspect
  nix-prefetch-scripts
  ];
}
