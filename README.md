# Polo's Awesome NixOS config !11!111!

Flake-based NixOS + Home Manager configuration for my machines (andromeda, milky)

## Layout

```
flake.nix                 # flake parts entry point
flake-modules/
  hosts.nix               # nixosConfigurations (one per machine; embeds Home Manager)
  packages.nix            # perSystem packages extracted from home/ (ida-pro, modelsim)
modules/system/           # reusable NixOS modules, each one is optional
  core/
  desktop/
  hardware/
  virt/
  gaming/
  security/
home/                     # Same as above but for home manager
  common.nix
  base/
  desktop/
  development/
  modding/
  electronics/
  gaming/  media/  apps/
pkgs/                     # heavy self-contained programs (own derivations)
  ida-pro/                # IDA Pro 9.4
  modelsim/               # ModelSim ASE
hosts/<machine>/          # boot, hardware-configuration, settings, options, home
secrets/                  # sops-encrypted secrets
```

The flake is assembled with [flake-parts](https://flake.parts/). `flake-modules/`
defines the flake outputs; `modules/system` and `home` are plain NixOS/Home
Manager modules selected per machine.

Home Manager is embedded in NixOS: each host sets `home-manager.users.<user> =
import ./home.nix`

## Per-machine capability

A machine's capabilities are just the modules it imports. Edit the matching
`hosts/<machine>/home.nix` (Home Manager) or `configuration.nix` (system).

To move a capability, add or remove the import in `hosts/<machine>/home.nix` ex:

```nix
imports = [
  ../../home/common.nix
  ../../home/base
  ../../home/desktop
  ../../home/development
  ../../home/electronics
];
```

The system side works the same way, e.g. `../../modules/system/gaming/steam.nix`.

## Commands

```sh
sudo nixos-rebuild switch --flake .#andromeda
sudo nixos-rebuild switch --flake .#sagittarius

# Build the standalone programs
nix build .#ida-pro
nix build .#modelsim

# Validate everything without building
nix flake check --no-build
```

## Secrets

`secrets/secrets.yaml` is encrypted with sops. It is consumed by both the NixOS `sops-nix`
module (`modules/system/core/sops.nix`) and Home Manager (`home/common.nix`).

## Large installer caveat

`pkgs/ida-pro/ida-pro_94_x64linux.run` (557 MB) and
`pkgs/modelsim/ModelSimSetup-20.1.1.720-linux.run` (1.4 GB) are **staged in the git index but intentionally not committed**. You will have to get them yourself lil bro
