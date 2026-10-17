# Generic system-wide packages. Category-specific packages live next to the
# modules that need them (virt/, gaming/, hardware/, desktop/).
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Coding shi
    kitty
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    direnv
    git
    opencode
    devenv

    # Normal packages
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
    parted
    gvfs # Thunar dep
    brightnessctl
    fprintd # Fingerprint reader
    zip
    fzf
    nh # nix

    # Keyboard
    via
    qmk
  ];
}
