{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../modules/system/core/options.nix
    ../themes/nixy.nix
    ./android.nix
    ./cli.nix
    ./dconf.nix
    ./extra.nix
    ./firefox/firefox.nix
    ./fish.nix
    ./git.nix
    ./gtk.nix
    ./kitty.nix
    ./neovim
    ./modding/ida.nix
    ./electronics/modelsim.nix
    ./opencode.nix
    ./pi
    ./qt.nix
    ./wofi.nix
    ./starship.nix
    ./vscode.nix
    ./xdg.nix
    ./hyprland
    ./hyprlock
    ./hypridle
    ./hyprpaper
    ./wayle.nix
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
  };

  # Enable ModelSim FPGA simulator with default configuration
  programs.modelsim.enable = true;

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
