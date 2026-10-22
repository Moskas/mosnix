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
    ];
  };
  flake.nixosModules.laffey =
    { config, ... }:
    {
      imports =
        (with self.nixosModules; [
          deluge
          forgejo
          glance
          grocy
          immich
          jellyfin
          terminal
          n8n
          nvidia
          samba
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
