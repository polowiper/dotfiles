# Steam plus the AMD/OpenCL runtime bits and protonup.
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Davinci Resolve runtime deps (the app itself is not installed)
    rocmPackages.clr
    ocl-icd

    protonup-qt
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
