# NixOS configuration

Flake-based NixOS + Home Manager configuration for two machines.

## Layout

```
flake.nix                 # thin entry point (flake-parts)
flake-modules/
  hosts.nix               # nixosConfigurations (one per machine)
  home.nix                # homeConfigurations (one per machine, standalone HM)
  packages.nix            # perSystem packages extracted from home/ (ida-pro, modelsim)
modules/system/           # reusable NixOS modules, opt-in per machine
  core/                   # options, fonts, locale, sops, nix daemon, users, packages
  desktop/                # audio, bluetooth, power, xserver, hyprland, thunar, sddm, gnome, ...
  hardware/               # fingerprint, udev (wheel/stlink/keyboard)
  virt/                   # libvirtd/qemu/spice
  gaming/                 # steam
  security/               # mullvad, usbguard, openssh
home/                     # reusable Home Manager categories, opt-in per machine
  common.nix              # shared HM core (identity, sops, nixpkgs policy)
  base/                   # theme/stylix, shell, git, gtk, xdg, cli, packages
  desktop/                # hyprland stack, wayle, wofi, kitty, qt, dconf, packages
  development/            # neovim, vscode, opencode, pi, android, packages
  modding/                # ida-pro + reversing packages
  electronics/            # modelsim + STM32/FPGA/KiCad packages
  gaming/  media/  apps/  # packages
pkgs/                     # heavy self-contained programs (own derivations)
  ida-pro/                # IDA Pro 9.4 + ida-mcp
  modelsim/               # ModelSim ASE (extract/FHS/wrappers)
hosts/<machine>/          # boot, hardware-configuration, settings, options, home
secrets/                  # sops-encrypted secrets
```

The flake is assembled with [flake-parts](https://flake.parts/). `flake-modules/`
defines the flake outputs; `modules/system` and `home` are plain NixOS/Home
Manager modules selected per machine.

## Per-machine capability matrix

A machine's capabilities are just the modules it imports. Edit the matching
`hosts/<machine>/home.nix` (Home Manager) or `configuration.nix` (system).

| Category        | andromeda | sagittarius |
| --------------- | :-------: | :---------: |
| base            |    ✅     |     ✅      |
| desktop         |    ✅     |     ✅      |
| development     |    ✅     |     ✅      |
| modding (IDA)   |    ✅     |      —      |
| electronics     |    ✅     |      —      |
| gaming          |    ✅     |      —      |
| media           |    ✅     |     ✅      |
| apps            |    ✅     |     ✅      |

To move a capability, add or remove the import in `hosts/<machine>/home.nix`, e.g.:

```nix
imports = [
  ../../home/common.nix
  ../../home/base
  ../../home/desktop
  ../../home/development
  ../../home/electronics   # <-- add this line on sagittarius
];
```

The system side works the same way, e.g. `../../modules/system/gaming/steam.nix`.

## Commands

```sh
# System
sudo nixos-rebuild switch --flake .#andromeda
sudo nixos-rebuild switch --flake .#sagittarius

# Home Manager (standalone)
home-manager switch --flake .#polo@andromeda
home-manager switch --flake .#polo@sagittarius

# Build the standalone programs
nix build .#ida-pro
nix build .#modelsim

# Validate everything without building
nix flake check --no-build
```

## Secrets

`secrets/secrets.yaml` is encrypted with sops (age key at
`~/.config/sops/age/keys.txt`). It is consumed by both the NixOS `sops-nix`
module (`modules/system/core/sops.nix`) and Home Manager (`home/common.nix`).

## Large installer caveat

`pkgs/ida-pro/ida-pro_94_x64linux.run` (557 MB) and
`pkgs/modelsim/ModelSimSetup-20.1.1.720-linux.run` (1.4 GB) are **staged in the
git index but intentionally not committed**. Nix's dirty-tree flake source only
sees tracked/staged files, which is why they must stay in the index (otherwise
`nix build .#ida-pro` / `.#modelsim` fails with "not tracked by Git"). Always
commit with explicit paths (or unstage the two files first) so they do not land
in history.

Recommended follow-up (not done here, because it rewrites history): move these
installers to a separate repository / git-lfs / external storage and fetch them
with `fetchurl` + a fixed hash, then run `git filter-repo` to drop them from
history. `.git` is currently ~3.7 GB because of them.

## Known dead code

- `home/base/yazi.nix` and `home/desktop/wezterm/` are **not imported** by any
  category (matching the state before this refactor). Decide whether to wire
  them up or delete them.
- `TODO` is the original scratch list.
