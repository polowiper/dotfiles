# Shared NixOS-side Home Manager setup.
#
# Home Manager is embedded in NixOS: a single `nixos-rebuild switch` applies
# both the system and the user configuration. Each host then sets
# `home-manager.users.<user> = import ./home.nix`.
{
  inputs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    # Install Home Manager packages through `users.users.<name>.packages`.
    useUserPackages = true;

    # Move aside pre-existing real files instead of failing activation. This
    # matters when migrating from standalone Home Manager, where some files
    # (e.g. ~/.config/qt6ct/qt6ct.conf) are not yet managed symlinks.
    backupFileExtension = "hm-backup";

    # `inputs` is used by the Home Manager modules (sops-nix, stylix, the IDA
    # package, etc.).
    extraSpecialArgs = {inherit inputs;};
  };
}
