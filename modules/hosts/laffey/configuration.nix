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
    imports = with self.nixosModules; [
      common
      deluge
      forgejo
      glance
      grocy
      immich
      jellyfin
      moskasProfile
      n8n
      nvidia
      samba
      sops
      tsnsrvProxy
      vaultwarden
      vm-test
    ];

    moskas.profile = "terminal";

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
