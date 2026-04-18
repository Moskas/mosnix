# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS flake configuration ("Moskas' Dendritic Flake") managing multiple hosts using flake-parts for modular composition. It uses Lix (a Nix fork) as the package manager on all hosts.

## Common Commands

Enter the devshell first to get the development tools (nixfmt, deadnix, statix, sops, etc.):
```bash
nix develop
```

**Build a host configuration:**
```bash
nixos-rebuild build --flake ".#<hostname>"
```

**Switch a local host:**
```bash
nixos-rebuild switch --flake ".#<hostname>"
# Or using nh (preferred, wraps nixos-rebuild with better output):
nh os switch . -- --flake ".#<hostname>"
```

**Deploy to a remote host (devshell command):**
```bash
deploy <hostname>
# Equivalent to: nixos-rebuild switch --flake ".#<hostname>" --target-host <hostname> --ask-sudo-password
```

**Format Nix files:**
```bash
nixfmt-tree .    # formatter configured via flake's perSystem
# or inside devshell:
nixfmt <file>
```

**Lint/check:**
```bash
deadnix .        # find dead Nix code
statix check .   # lint Nix code
```

## Architecture

### Flake Structure

The flake uses `flake-parts` with `importTree` to automatically import all `.nix` files under `modules/` (excluding `flake.nix` itself). This means **every `.nix` file in `modules/` is automatically loaded** — no manual import list needed.

### Module Layout

```
modules/
  parts.nix               # flake-parts config: systems, home-manager flakeModule
  shells/default.nix      # devshell with tools + deploy command
  features/
    home-manager.nix      # moskasHomeManager, minimalHome, fullHome nixosModules
    home/                 # individual home-manager program modules (each exported as homeModule)
    nixos/
      common/             # common nixosModule (nix settings, packages, overlays)
      stylix.nix          # stylixConfig nixosModule with moskas.colorscheme option
      niri.nix            # niri wayland compositor module
      laptop.nix, ly.nix, secureboot.nix
  hosts/
    <hostname>/
      default.nix         # imports hardware, disko, configuration, style
      configuration.nix   # host-specific nixosConfiguration + nixosModule definition
      hardware.nix        # hardware-configuration.nix equivalent
      disko.nix           # disk partitioning layout
      home.nix            # host-specific home-manager overrides
      style.nix           # host-specific stylix/colorscheme settings (where present)
```

### Hosts

| Host | Role | Notes |
|------|------|-------|
| nagato | server/minimal | minimalHome, stylix |
| kashino | desktop | Japanese keyboard layout |
| kinu | — | — |
| shimakaze | — | — |
| noshiro | — | — |
| glasgow | laptop | ThinkPad X220, fullHome, niri, fingerprint reader disabled |

### Key nixosModules (defined via flake-parts)

- `common` — baseline NixOS config: Lix, nix settings, dev tools (nh, nix-tree, nixd, etc.), binary caches (nix-community, moskas.cachix.org)
- `moskasHomeManager` — wires home-manager for user `moskas`, applies emacs-overlay and llm-agents overlays
- `minimalHome` — subset of home modules (btop, git, ranger, starship, zoxide, zsh)
- `fullHome` — full home module set including bat, claude, direnv, emacs, firefox, opencode
- `stylixConfig` — theming via stylix/base16; exposes `moskas.colorscheme` option (default: `gruvbox-dark-medium`)

### Adding a New Host

1. Create `modules/hosts/<hostname>/` with `default.nix`, `configuration.nix`, `hardware.nix`, `disko.nix`, and optionally `home.nix`/`style.nix`.
2. In `configuration.nix`, define `flake.nixosConfigurations.<hostname>` and `flake.nixosModules.<hostname>`, composing from existing modules (`common`, `moskasHomeManager`, `stylixConfig`, `minimalHome`/`fullHome`, etc.).
3. Files are auto-imported — no changes needed to `flake.nix`.

### Secrets

SOPS + age is used for secrets management (`sops-nix` input, `sops` and `age` in devshell).

### Theming

All theming goes through stylix. Override `moskas.colorscheme` per host to change the base16 scheme. The font stack defaults to JetBrains Mono Nerd Font throughout.
