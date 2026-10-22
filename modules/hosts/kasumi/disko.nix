{ inputs, ... }:
{
  # Hetzner Cloud VPS: legacy BIOS boot, single virtio disk. Installed with
  # nixos-anywhere, which formats it from this layout.
  flake.nixosModules.kasumi = {
    imports = [
      inputs.disko.nixosModules.default
    ];
    config = {
      disko.devices = {
        disk = {
          main = {
            device = "/dev/sda";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                # GRUB core image for BIOS boot; disko adds this disk to
                # boot.loader.grub.devices because of it.
                boot = {
                  size = "1M";
                  type = "EF02";
                };
                root = {
                  size = "100%";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
