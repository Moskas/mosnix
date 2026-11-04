---
name: nix-env
description: Nix, NixOS, and Nix-based development environments. Use when working with Nix expressions, flakes, NixOS configurations, package availability, development shells, or troubleshooting missing commands and dependencies on NixOS.
---

# Nix & NixOS Environment

## General Environment

In NixOS, applications and development tools are not necessarily available in `$PATH`, even if they are installed or available in the Nix store.

When a required tool is unavailable, use the appropriate Nix command:

- `nix develop` — Enter a project's development environment.
- `nix shell` — Temporarily provide packages in the current environment.
- `nix run` — Run applications without installing them.
- `nix-shell` — Enter legacy development environments.

For example, Python might be available on the system but not included in the active environment's PATH. Use a Nix shell to provide it when needed.

Prefer declarative solutions over imperative system changes.

## Nix Shells & Development

- Always use the project's Nix development environment for dependencies when available.
- Check for `flake.nix`, `shell.nix`, and `.envrc` before running development commands.
- Prefer `nix develop` for flake-based projects and `nix-shell` for legacy projects.
- Use `nix shell` for temporary dependencies that are not part of the project environment.
- Use `nix run` when an application needs to be executed without installing it.
- Never install project dependencies globally on the host system.
- Use `direnv` when configured by the project.
- Do not introduce Nix configuration or dependencies without justification.
- Do not introduce flakes into projects that do not already use them unless explicitly requested.
- Respect the existing project's development environment and dependency management.

## Nix Code Style

- Prefer nested attribute sets over repeated fully qualified attributes.
- Group related configuration options together.
- Preserve existing formatting and module organization where possible.
- Avoid unnecessary restructuring when modifying existing configurations.

### Attribute Nesting

Avoid:

```nix
services.mpd.enable = true;
services.mpd.settings.port = 8020;
```

Prefer:

```nix
services.mpd = {
  enable = true;
  settings.port = 8020;
};
```

Use nesting when it improves readability and keeps related configuration together. Do not force nesting when it makes the structure harder to understand.

## NixOS Configuration

- Prefer declarative configuration over imperative system changes.
- Preserve the existing flake structure and module organization.
- Inspect relevant configuration files before modifying system options.
- Never modify secrets or generated files unless explicitly requested.
- Prefer building configurations before activating them.
- Never run `nixos-rebuild switch` without explicit user approval.
- Explain potentially disruptive system changes before executing them.
- Do not assume that a successful build means a configuration is safe to activate.

## Devices

- Refer to devices by their hostname.
- Hostnames correspond to device configurations in the NixOS configuration repository.
- Do not assume two devices have identical hardware or software configurations.
- Verify the target hostname before making device-specific changes.
- Check the relevant host configuration before assuming available hardware, services, or options.
- Avoid applying device-specific changes globally unless explicitly requested.
