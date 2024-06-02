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
    ./git.nix
    ./gtk.nix
    ./kitty.nix
    ./nixvim.nix
    ./nushell.nix
    ./mako.nix
    ./qt.nix
    ./rofi.nix
    ./spotify.nix
    ./starship.nix
    ./waybar.nix
    ./xdg.nix
    ./hyprland.nix
    ./hyprlock.nix
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.hyprland.homeManagerModules.default
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

 programs.vscode = {
  enable = true;
  extensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    ms-toolsai.jupyter
    ms-python.python
    vscodevim.vim
    yzhang.markdown-all-in-one
  ];
};


programs.home-manager.enable = true;
programs.home-manager.path = lib.mkDefault "${dotfilesDir}";
}

 
 
