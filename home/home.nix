{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  ida = pkgs.callPackage ./ida_pro/ida.nix {};
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./options.nix
    ../themes/catppuccin.nix
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
    ./wofi.nix
    ./starship.nix
    ./vscode.nix
    ./xdg.nix
    ./hyprland
    ./hyprlock
    ./hypridle
    ./hyprpaper
    ./hyprpanel
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "${config.var.userName}";
    homeDirectory = "/home/${config.var.userName}";
    stateVersion = "23.11";
    sessionVariables.EDITOR = "nvim";
    packages = [ida];
  };
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "eduroam_id" = {};
      "eduroam_pswd" = {};
      "vpn_id" = {};
    };
    age.keyFile = "/home/polo/.config/sops/age/keys.txt";
  };
  programs.home-manager.enable = true;
  programs.home-manager.path = lib.mkDefault "${config.var.dotfilesDir}";
}
