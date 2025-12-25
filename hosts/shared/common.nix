{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./locale.nix
    ./services.nix
    ./sops.nix
    ./sys.nix
    ./syspkgs.nix
    ./users.nix
    inputs.stylix.nixosModules.stylix
  ];
}
