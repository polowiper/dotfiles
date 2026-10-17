# Thunar + XFCE helpers (gvfs mounts/trash, tumbler thumbnails, xfconf).
{pkgs, ...}: {
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  programs.xfconf.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
}
