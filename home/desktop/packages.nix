{pkgs, ...}: {
  home.packages = with pkgs; [
    better-control
    overskride
    grim
    swappy
    slurp
    nwg-displays
  ];
}
