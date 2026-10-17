{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.stylix.homeModules.stylix
    ../modules/system/core/options.nix
  ];

  # Declared here so consumers (e.g. the pi MCP config) can read it regardless
  # of whether the modding category is imported.
  options.my.ida-mcp.enable = lib.mkEnableOption "the IDA Pro MCP server";

  config = {
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

    # NOTE: `programs.modelsim.enable` lives in home/electronics/default.nix,
    # so it is only declared when a machine imports the electronics category.

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
  };
}
