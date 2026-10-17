{pkgs, ...}: {
  home.packages = with pkgs; [
    osu-lazer

    # Wii
    wiimms-iso-tools
    rvz

    # Steam / Windows compat
    wine64
    winetricks
    protontricks
    wine-wayland

    # Minecraft
    temurin-bin
    prismlauncher

    oversteer # Wheel
  ];
}
