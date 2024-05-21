{
  #system/networking.nix 
  hostName = "nixos";

  #system/locale.nix
  theLocale = "en_US.UTF-8";
  theTimeZone = "Europe/Paris";

  #flake.nix
  system = "x86_64-linux";

  #system/fonts.nix
  fontName = "Monaspice Nerd Font";

  #Home manager et System comme ca les deux sont forcément synchros
  stateVersion = "23.11"; 
}
