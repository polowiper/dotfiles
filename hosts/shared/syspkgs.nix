{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wgetcon

  nixpkgs.overlays = [
    (final: prev: {
      davinci-resolve-studio = prev.davinci-resolve-studio.override (old: {
        buildFHSEnv = a:
          old.buildFHSEnv (
            a
            // {
              extraBwrapArgs =
                (a.extraBwrapArgs or [])
                ++ [
                  "--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL"
                ];
            }
          );
      });

      davinci-resolve-amd = final.davinci-resolve-studio;
    })
  ];

  environment.systemPackages = with pkgs; [
    # Coding shi
    kitty
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    direnv
    git
    opencode

    #Normal packages
    wl-clipboard
    oversteer # Wheel
    wget
    firefox
    xwayland
    yazi
    ripgrep
    ffmpeg
    imagemagick
    unzip
    helvum
    parted
    gvfs # Thunar dep
    brightnessctl
    fprintd # Fingerprint reader
    zip
    fzf
    nh # nix

    #Keyboard
    via
    qmk

    #VM
    phodav
    gnome-boxes
    dnsmasq
    qemu

    #Davinci resolve
    davinci-resolve-amd
    rocmPackages.clr
    ocl-icd
  ];
  programs.dconf.enable = true; # gnome
  programs.xfconf.enable = true; # xfce

  # Qemu shit
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  users.groups = {
    libvirtd.members = ["polo"];
    kvm.members = ["polo"];
  };

  # thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  programs.kdeconnect.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
}
