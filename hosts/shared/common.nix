{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./locale.nix
    ./options.nix
    ./services.nix
    ./sys.nix
    ./syspkgs.nix
    ./users.nix
  ];
}
