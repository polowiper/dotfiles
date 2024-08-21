{pkgs, ...}: 
{
 
 home.packages = with pkgs; [
  vial
  obs-studio
  xorg.xev
  osu-lazer-bin
  telegram-desktop

  scrcpy
  android-studio
  android-tools
  mitmproxy
  mitmproxy2swagger
  apktool
  ghex
  ida-free

  bitwarden-desktop
  prismlauncher-unwrapped
  nemo
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
