# Base user environment: shell, prompt, git, theming, xdg, CLI tools.
{...}: {
  imports = [
    ./theme.nix
    ./cli.nix
    ./fish.nix
    ./git.nix
    ./gtk.nix
    ./starship.nix
    ./xdg.nix
    ./packages.nix
  ];
}
