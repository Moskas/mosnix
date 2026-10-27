# Moskas' Dendritic Flake

NixOS configuration for all of my machines, built with
[flake-parts](https://flake.parts) in the dendritic pattern: every `.nix` file under `modules/` is
auto-imported and contributes to the flake directly, so there is no central import list.

- [Lix](https://lix.systems) as the Nix implementation on every host.
- [home-manager](https://github.com/nix-community/home-manager) as a NixOS module for the `moskas`
  user, so system and user configuration are built and switched together.
- mosnix (`modules/features/mosnix.nix`): the `moskas.*` options shared by NixOS and home-manager.
  A host sets the colorscheme, fonts, font sizes and bar layout once, and the values are mirrored
  into home-manager.
- [stylix](https://github.com/nix-community/stylix) for theming, driven by `moskas.colorscheme`
  (default `gruvbox-dark-medium`).

## Hosts

Each device is named after a warship from Azur Lane. The ship class follows how "heavy" the machine
is: servers are battleships and carriers, desktops are heavy cruisers, laptops are light cruisers,
and small or mobile machines are destroyers. With some exceptions (`laffey`) but you get the gist.

|                                                   | Name      | Type    | Description                                    | Profile       |
|---------------------------------------------------|-----------|---------|------------------------------------------------|---------------|
| <img src="assets/hosts/cheshire.png" width="48">  | cheshire  | Desktop | Main workstation and gaming machine            | `graphical`   |
| <img src="assets/hosts/noshiro.png" width="48">   | noshiro   | Laptop  | ThinkPad T480                                  | `graphical`   |
| <img src="assets/hosts/glasgow.png" width="48">   | glasgow   | Laptop  | ThinkPad X220                                  | `graphical`   |
| <img src="assets/hosts/kashino.png" width="48">   | kashino   | Laptop  | Thinkpad T430                                  | `graphical`   |
| <img src="assets/hosts/akashi.png" width="48">    | akashi    | Laptop  | ThinkPad X60                                   | `lightweight` |
| <img src="assets/hosts/laffey.png" width="48">    | laffey    | Server  | Homeserver                                     | `terminal`    |
| <img src="assets/hosts/kasumi.png" width="48">    | kasumi    | VPS     | VPS                                            | `terminal`    |
| <img src="assets/hosts/nagato.png" width="48">    | nagato    | Server  | Dell Wyse 3040 thin client                     | `terminal`    |
| <img src="assets/hosts/kinu.png" width="48">      | kinu      | Laptop  | Testing minimal 32-bit (i686) system           | none          |
| <img src="assets/hosts/shimakaze.png" width="48"> | shimakaze | WSL     | For when I have to use Windows with sane tools | `terminal`    |

Profiles are feature aggregates exported as both a nixosModule and a homeModule:

- `terminal`: base CLI feature set
- `graphical`: `terminal` plus niri, ly and the GUI feature set
- `lightweight`: `terminal` plus sway, ly, waybar and foot, for GPUs that cannot run niri

## Layout

```
modules/
  parts.nix             flake-parts config, systems
  shells/               devshell (deploy, vm, update-wallpapers)
  features/
    mosnix.nix          moskas.* options (colorscheme, fonts, bar)
    profiles/           terminal, graphical, lightweight aggregates
    home/               home-manager modules
    nixos/              NixOS modules
    servers/            self-hosted services
    secrets/            sops-nix setup and secrets.yaml
  hosts/<hostname>/
    configuration.nix   nixosConfiguration + host nixosModule
    hardware.nix        hardware-configuration.nix as a flake module
    disko.nix           disk layout
```

## Usage

```sh
nix develop                                # devshell with nixfmt, deadnix, statix, sops, disko
nh os switch . -- --flake ".#<hostname>"   # switch the local host
deploy <hostname>                          # switch a remote host over SSH
vm <hostname>                              # build and run a test VM
nixfmt $(git ls-files '*.nix')             # format
```

## Installing on a new host

### 1. Define the host

Create `modules/hosts/<hostname>/` with three files. Each one contributes to the same
`flake.nixosModules.<hostname>`, so they are merged automatically.

`configuration.nix`:

```nix
{ self, inputs, ... }:
{
  flake.nixosConfigurations.<hostname> = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.<hostname> ];
  };

  flake.nixosModules.<hostname> = {
    imports = [
      self.nixosModules.commonWorkstation
      self.nixosModules.graphical
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
    ];

    networking.hostName = "<hostname>";
  };
}
```

`disko.nix`: copy one from an existing host with similar hardware (e.g. `akashi` for legacy BIOS,
`noshiro` for UEFI) and adjust `device`.

`hardware.nix`: filled in from the target machine in step 4. Start with an empty module so the
flake evaluates:

```nix
{
  flake.nixosModules.<hostname> = { };
}
```

Commit or at least `git add` the new files; flakes only see tracked files.

### 2. Build the installer ISO

```sh
nix build .#installer-iso
sudo dd if=result/iso/nixos-minimal-<version>.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

The ISO ships Lix, the flake's binary caches and SSH with keys authorized, so the install can be
done remotely with `ssh -A nixos@<ip>`.

### 3. Partition with disko

Boot the ISO, then:

```sh
git clone ssh://forgejo@laffey/Moskas/dendritic-nix.git
cd dendritic-nix
nix develop
sudo disko --mode destroy,format,mount --flake .#<hostname>
```

### 4. Generate hardware config

```sh
nixos-generate-config --no-filesystems --root /mnt --show-hardware-config
```

Move the body of the output into `hardware.nix`, wrapped as the host's module:

```nix
{
  flake.nixosModules.<hostname> =
    { config, lib, modulesPath, ... }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
      config = {
        boot.initrd.availableKernelModules = [ ... ];
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      };
    };
}
```

Filesystems are declared in `disko.nix` and it handles formating, partitioning and encryption of drives. `hardware.nix` handles only detected modules and system architecture.

### 5. Install

```sh
git add modules/hosts/<hostname>
sudo nixos-install --flake .#<hostname> --no-root-passwd
sudo nixos-enter --root /mnt -c 'passwd moskas'
reboot
```

Commit `hardware.nix` and push it from the new host, or copy it back to another machine.

### Remote install

For machines that are already running Linux and reachable over SSH or after you have booted up custom iso, you can with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) partition and install in
one step. Fill in `hardware.nix` first (step 4, run on the target), since nixos-anywhere's own
`--generate-hardware-config` writes a plain NixOS module that the flake-parts import tree cannot
load.

```sh
nix run github:nix-community/nixos-anywhere -- --flake .#<hostname> root@<ip>
```

### Secrets

Hosts that import `self.nixosModules.sops` generate an age key at `/var/lib/sops-nix/key.txt` on
first boot. Add its public key as a recipient in `.sops.yaml`, re-encrypt, then redeploy:

```sh
sudo age-keygen -y /var/lib/sops-nix/key.txt   # on the new host
# add the key under `keys` and the secrets.yaml creation rule in .sops.yaml
sops updatekeys modules/features/secrets/secrets.yaml
```

### Secure Boot

Hosts with UEFI Secure Boot support use [lanzaboote](https://github.com/nix-community/lanzaboote)
through `self.nixosModules.secureboot`. The module replaces systemd-boot, and
generates and enrolls its own keys under `/var/lib/sbctl` on boot.

Enable it only after the host has been installed and booted with plain systemd-boot:

1. Reboot into the firmware, clear the Secure Boot keys to put it in Setup Mode, leave Secure Boot
   disabled.
2. Add `self.nixosModules.secureboot` to the host's imports and switch. Lanzaboote generates the
   keys, signs the boot files, enrolls the keys and reboots.
3. Enable Secure Boot in the firmware.
4. Verify:

```sh
bootctl status | grep "Secure Boot"   # Secure Boot: enabled (user)
nix shell nixpkgs#sbctl -c sudo sbctl verify
```

Keep a copy of `/var/lib/sbctl` with the host's backups; losing it means re-enrolling from Setup
Mode.

## Why NixOS?

Since I have multiple devices and use some more frequently than others, I've had more than one
occurrence of, for example, my laptop being out of date compared to the desktop, and I've simply
missed some of my configurations or software that I've changed in the meantime.

It was annoying and tedious to keep everything up-to-date on every device, especially when I
installed additional applications on one host and removed some on another.

So when I have learned about NixOS, I knew it was something that would help me with that. I tested it on
my laptop for about half a year, then I decided to fully switch to it on all my devices and
transition from `channels` to `flake` for even easier multidevice management.

I try to declaratively manage everything on my devices if I find some application that I would like to use and it's not packaged or has no nixos/home-manager module I create it.
