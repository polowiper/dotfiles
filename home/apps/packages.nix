# Miscellaneous GUI applications.
{pkgs, ...}: {
  home.packages = with pkgs; [
    vial
    kotatogram-desktop # tg
    karere # whatsapp
    onlyoffice-desktopeditors
    orca-slicer # 3D printer
    droidcam
    freecad
    gimp
    deluge
    letos
    gradia
    scilab-bin
    qalculate-gtk
    monero-gui
    mullvad-vpn
    lorien
  ];
}
