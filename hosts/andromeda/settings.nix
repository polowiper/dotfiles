{config, ...}: let
  inherit (import ./options.nix) hostName;
in {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Enable flakes
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  networking = {
    hostName = "${hostName}"; # Define your hostname.
    #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
    wireless.networks = {
      "eduroam" = {
        auth = ''
          key_mgmt=WPA-EAP
          eap=PWD
          identity=${builtins.readFile config.sops.secrets."eduroam_id".path}
          password=${builtins.readFile config.sops.secrets."eduroam_pswd".path}
        '';
      };
    };
    domain = "localdomain";

    extraHosts = ''
      127.0.0.1 nixos.localdomain nixos
    '';
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NH_FLAKE = "/home/polo/nixos/";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #PIPEWIRESHIT
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
