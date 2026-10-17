# SDDM display manager with the SilentSDDM theme and the user's profile picture.
{
  pkgs,
  inputs,
  config,
  ...
}: let
  sddm-theme = inputs.silentSDDM.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    theme = "catppuccin-mocha";
  };
  pfp = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/polowiper/Wallpapers/refs/heads/main/pfp.jpg";
    sha256 = "sha256-a9ojZeT+BBPpmXXSupz36tUe8b5gtdZZY+XrNIgs+8k=";
  };
  sddm-faces = pkgs.runCommand "sddm-faces" {} ''
    mkdir -p $out
    # Priority order
    cp ${pfp} $out/.face.icon
    cp ${pfp} $out/root.face.icon
    cp ${pfp} $out/${config.var.userName}.face.icon
  '';
in {
  environment.systemPackages = [
    sddm-theme
    sddm-theme.test
  ];
  qt.enable = true;
  services.displayManager.sddm = {
    package = pkgs.kdePackages.sddm; # use qt6 version of sddm
    enable = true;
    theme = sddm-theme.pname;
    # the following changes will require sddm to be restarted to take
    # effect correctly. It is recommended to reboot after this
    extraPackages = sddm-theme.propagatedBuildInputs;
    settings = {
      # required for styling the virtual keyboard
      Theme = {
        FacesDir = "${sddm-faces}";
      };
      General = {
        GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
        InputMethod = "qtvirtualkeyboard";
      };
    };
  };
}
