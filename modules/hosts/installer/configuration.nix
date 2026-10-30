{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      self.nixosModules.installer
      self.nixosModules.caches
    ];
  };

  flake.nixosModules.installer =
    { pkgs, ... }:
    {
      # ── ISO image settings ─────────────────────────────────────────────────
      isoImage = {
        # Faster compression: good balance between speed and size
        squashfsCompression = "zstd -Xcompression-level 6";
        makeEfiBootable = true;
        makeUsbBootable = true;
      };

      # isoImage.isoName was renamed to image.fileName in recent nixpkgs
      image.fileName = lib.mkForce "moskas-installer.iso";

      # Silence ZFS warning — we're not using ZFS on the installer
      boot.zfs.forceImportRoot = false;

      networking = {
        hostName = "nixos-installer";
        firewall.allowedTCPPorts = [ 22 ];
      };

      # ── SSH server ─────────────────────────────────────────────────────────
      # Machines can SSH into the installer (e.g. to use it as a remote builder)
      services.openssh = {
        enable = true;
        settings = {
          # Allow root login via key — required for nix remote builds
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
          LoginGraceTime = 0;
        };
      };

      # All known moskas machine keys can SSH in as root or the live nixos user
      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcyn8bcHt95Md8h93x630f2gfsTqaiwHXDyvu+iyuKW moskas@cheshire"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpoSvwjWLgKtwr9e/VEsh2fNw39aEsSdSUdqxCEqFYQ moskas@roon"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwxli8p6YHNTHlr+LYrYELUMfyNg8mwLtqGgcMy4FIa nix-on-droid@boise"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqhJIblbfCgvzBAetg9qzlHyL19hiqMdKwPnc9MJIuM moskas@shimakaze"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqY9eUP1BDb71ejfs/a6AZN02VGtNqapu3ttCcmPo98 moskas@noshiro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChr50iFARqmJBKcPe+LdNvDnO0bza9ImKmYPlcT8CBi u0_a442@localhost"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGICKZja7UpBN4XgLALba57OQKJY1n1YodatdXjiEIGD moskas@glasgow"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTEit4avXKGhETGMQxNNf5Xf8Q3Pl+kR2e31ZmJcHX/ moskas@kashino"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINA85XG42xoNsT2TijRbXyfsgyNmffv2WnCK0EuoCGu+ moskas@akashi"
      ];

      users.users.nixos.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcyn8bcHt95Md8h93x630f2gfsTqaiwHXDyvu+iyuKW moskas@cheshire"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpoSvwjWLgKtwr9e/VEsh2fNw39aEsSdSUdqxCEqFYQ moskas@roon"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwxli8p6YHNTHlr+LYrYELUMfyNg8mwLtqGgcMy4FIa nix-on-droid@boise"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqhJIblbfCgvzBAetg9qzlHyL19hiqMdKwPnc9MJIuM moskas@shimakaze"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqY9eUP1BDb71ejfs/a6AZN02VGtNqapu3ttCcmPo98 moskas@noshiro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChr50iFARqmJBKcPe+LdNvDnO0bza9ImKmYPlcT8CBi u0_a442@localhost"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGICKZja7UpBN4XgLALba57OQKJY1n1YodatdXjiEIGD moskas@glasgow"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTEit4avXKGhETGMQxNNf5Xf8Q3Pl+kR2e31ZmJcHX/ moskas@kashino"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINA85XG42xoNsT2TijRbXyfsgyNmffv2WnCK0EuoCGu+ moskas@akashi"
      ];

      # ── SSH client ─────────────────────────────────────────────────────────
      # When you SSH into the installer with -A (agent forwarding), the
      # forwarded agent lets the installer SSH into your other machines.
      programs.ssh.extraConfig = ''
        Host *
          ForwardAgent yes
          # Accept new host keys on first connect (fine for an installer)
          StrictHostKeyChecking accept-new
          ServerAliveInterval 60
      '';

      # ── Nix — remote building support ─────────────────────────────────────
      nix = {
        package = pkgs.lixPackageSets.stable.lix;

        # Expose the installer's nix-daemon over SSH so other machines can
        # add it as a build host via nix.buildMachines
        sshServe = {
          enable = true;
          write = true;
        };

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          # root and wheel can submit builds; nix-ssh is the nix sshServe user
          trusted-users = [
            "root"
            "@wheel"
            "nix-ssh"
          ];
          builders-use-substitutes = true;
        };
      };

      # ── Packages ───────────────────────────────────────────────────────────
      environment.systemPackages = with pkgs; [
        git
        neovim
        wget
        curl
        # Disk tooling
        parted
        gptfdisk
        cryptsetup
        # Nix tooling
        nixd
        nix-output-monitor
      ];

      nixpkgs.config.allowUnfree = true;

      system.stateVersion = "25.11";
    };

  # ── Package output ──────────────────────────────────────────────────────────
  # Build with: nix build .#installer-iso  (or .#packages.x86_64-linux.installer-iso)
  perSystem =
    { system, ... }:
    lib.optionalAttrs (system == "x86_64-linux") {
      packages.installer-iso = self.nixosConfigurations.installer.config.system.build.isoImage;
    };
}
