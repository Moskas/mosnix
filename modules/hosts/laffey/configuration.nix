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
  flake.nixosModules.laffey = {
    imports =
      (with self.nixosModules; [
        common
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
  };
}
