{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./locale.nix
    ./services.nix
    ./sys.nix
    ./syspkgs.nix
    ./users.nix
  ];
}
