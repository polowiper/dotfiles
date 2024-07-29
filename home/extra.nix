{pkgs, ...}: 
{
 
 home.packages = with pkgs; [
  vial
  obs-studio
  xorg.xev
  osu-lazer-bin
  telegram-desktop
  scrcpy
  android-tools
  bitwarden-desktop
  prismlauncher-unwrapped
  cinnamon.nemo
  nautilus-open-any-terminal
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
