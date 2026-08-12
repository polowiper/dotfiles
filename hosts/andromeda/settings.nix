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
    # wireguard.interfaces = {
    #   wg0 = {
    #     # L'adresse IP locale de ton PC NixOS dans le tunnel VPN
    #     ips = ["10.0.0.3/32"];
    #
    #     # ICI : On pointe directement vers le chemin du fichier généré par SOPS
    #     privateKeyFile = config.sops.secrets.homelab_vpn_key.path;
    #
    #     peers = [
    #       {
    #         publicKey = "DCYlW8qZm2zuw3iwLcZC+s4nv8HYHjKhocRxcmxWgx4=";
    #
    #         endpoint = "ton618.host:51820";
    #
    #         #Full tunel
    #         allowedIPs = ["0.0.0.0/0"];
    #
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
    networkmanager.enable = true;
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
