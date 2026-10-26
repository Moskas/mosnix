{
  self,
  inputs,
  lib,
  ...
}:

{
  flake.nixosConfigurations.laffey = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laffey
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
    ];
  };
  flake.nixosModules.laffey =
    { config, ... }:
    {
      imports =
        (with self.nixosModules; [
          atuin
          deluge
          forgejo
          glance
          grocy
          harmonia
          immich
          jellyfin
          terminal
          n8n
          nvidia
          samba
          slideRenderer
          slskd
          searx
          sops
          tsnsrvProxy
          vaultwarden
          vm-test
        ])
        ++ [
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];

      boot.loader = {
        grub = {
          enable = true;
          device = "nodev";
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
        systemd-boot.enable = lib.mkForce false;
      };

      networking.hostName = "laffey";

      # Builds (local, --build-host and CI) share the box with the services, so they get
      # at most half the cores, low CPU/IO priority and a memory cap: a runaway build is
      # throttled and then OOM-killed inside the daemon's cgroup instead of taking immich down
      nix = {
        settings = {
          max-jobs = 2;
          cores = 2;
        };
        daemonCPUSchedPolicy = "batch";
        daemonIOSchedClass = "idle";
        # Keeps generations, and the cache paths they hold, around longer than the default 7d
        gc.options = lib.mkForce "--delete-older-than 21d";
      };
      systemd.services.nix-daemon.serviceConfig = {
        MemoryHigh = "6G";
        MemoryMax = "8G";
      };

      # GTX 960 (Maxwell): unsupported by the open modules and the production
      # driver, so pin the last proprietary branch that still covers it.
      hardware.nvidia = {
        open = false;
        package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };

      # First installed on 22.11; stateful defaults (postgresql 14 data dir
      # for immich, etc.) depend on it. Do not bump.
      system.stateVersion = lib.mkForce "22.11";
    };
}
