# Core system concerns shared by every machine: options, fonts, locale, sops,
# nix daemon tuning, users and generic packages.
{...}: {
  imports = [
    ./options.nix
    ./fonts.nix
    ./locale.nix
    ./sops.nix
    ./sys.nix
    ./users.nix
    ./packages.nix
    ./home-manager.nix
  ];
}
