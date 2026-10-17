{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.android_sdk.accept_license = true;
  home.packages = with pkgs; [
    android-studio
    scrcpy
    android-tools
    apktool
    httptoolkit-server
    httptoolkit
    temurin-bin # To be able to export JAVA_HOME, if not using android-studio-full
  ];
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/.android/Android/sdk";
    ANDROID_SDK_ROOT = "$HOME/.android/Android/sdk";
    JAVA_HOME = "${pkgs.temurin-bin}";
  };
}
