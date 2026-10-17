{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../modules/system/core/options.nix
    ./base
    ./desktop
    ./development
    ./modding
    ./electronics
    ./gaming
    ./media
    ./apps
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
