{inputs, pkgs, lib, ...}:

let
  inherit (import ./options.nix) userName dotfilesDir;
  inherit (import ../system/options.nix) stateVersion;
in {
  imports = [
    ./cli.nix
    ./discord.nix
    ./extra.nix
    ./firefox/firefox.nix
    ./fish.nix
    ./git.nix
    ./gtk.nix
    ./kitty.nix
    ./nixvim.nix
    ./mako.nix
    ./qt.nix
    ./rofi.nix
    ./spotify.nix
    ./starship.nix
    ./vscode.nix
    ./waybar.nix
    ./xdg.nix
    ./hyprland.nix
    ./hyprlock.nix
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "${userName}";
    homeDirectory = "/home/${userName}";
    stateVersion = "${stateVersion}"; #ALLAH AKBAR
    sessionVariables.EDITOR = "nvim";
  };

programs.home-manager.enable = true;
programs.home-manager.path = lib.mkDefault "${dotfilesDir}";
}

 
 
