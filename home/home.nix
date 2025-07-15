{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (import ./options.nix) userName dotfilesDir;
  inherit (import ../system/options.nix) stateVersion;
  ida = pkgs.callPackage ./ida_pro/ida.nix {};
in {
  imports = [
    ./cli.nix
    ./dconf.nix
    ./extra.nix
    ./firefox/firefox.nix
    ./fish.nix
    ./git.nix
    ./gtk.nix
    ./kitty.nix
    ./neovim
    ./mako.nix
    ./qt.nix
    ./rofi.nix
    ./starship.nix
    ./vscode.nix
    # ./waybar.nix
    ./testwaybar.nix
    ./wezterm/wezterm.nix
    ./xdg.nix
    ./hyprland.nix
    ./hyprlock.nix
    inputs.catppuccin.homeModules.catppuccin
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "${userName}";
    homeDirectory = "/home/${userName}";
    stateVersion = "${stateVersion}"; # ALLAH AKBAR
    sessionVariables.EDITOR = "nvim";
    packages = [ida];
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = lib.mkDefault "${dotfilesDir}";
}
