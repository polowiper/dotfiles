{
  #system/networking.nix
  hostName = "sagittarius";

  #flake.nix
  system = "x86_64-linux";

  #Home manager et System comme ca les deux sont forcément synchros
  stateVersion = "23.11";
}
