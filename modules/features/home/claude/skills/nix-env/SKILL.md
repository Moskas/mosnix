---
name: nix-env
description: Nix and NixOS development environment and how to handle it
---

In nix/nixos not every dependency or dev application might be in the $PATH by default. If needed use `nix dev shells` or `nix run`.

For instance python might be in the system but it's not declared in the system closure so that's where the nix shell comes in.

## Nix Shells
- Always use `nix-shell` or `nix develop` for project dependencies
- Check for `shell.nix` or `flake.nix` in project root before installing packages
- Run commands inside the nix-shell environment, not the host system
- Example: `nix-shell -p nodejs python3 --run "npm install"`

## Nix code format
When writing nix code try to use nesting where applicable, it will shorten the lines and will be easier to parse the text at glance. Like:
### Don't
```nix
services.mpd.enable = true;
services.mpd.settings.port=8020;
```
### Do
```nix
services.mpd = {
  enable = true;
  settings.port = 8020;
};
```
