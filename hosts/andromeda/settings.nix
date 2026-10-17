{
  config,
  pkgs,
  ...
}: let
  inherit (import ./options.nix) hostName;
in {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Enable flakes
  nix.settings = {
    trusted-users = [
      "root"
      "polo"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "ssh-ng://alpine-builder"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "builder-name:GHpEwaOemSqdwOBKBpE1tZlhtrYBRxVi2ko19+q7DHo=" # Yeahhh baby
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  networking = {
    hostName = "${hostName}"; # Define your hostname.
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
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

  nix = {
    buildMachines = [
      {
        hostName = "192.168.1.81"; # Utilise l'IP directe plutôt que l'alias SSH
        protocol = "ssh-ng";
        sshUser = "root";
        sshKey = "/etc/nix/remotebuild_key"; # Chemin absolu vers la clé privée
        system = "x86_64-linux";
        maxJobs = 64;
        speedFactor = 8;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
          "gccarch-x86-64"
        ];
      }
    ];

    distributedBuilds = true;

    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

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
