{ inputs, ... }:
{
  flake.nixosModules.akashi = {
    imports = [
      inputs.disko.nixosModules.default
    ];
    config = {
      disko.devices = {
        disk = {
          main = {
            type = "disk";
            device = "/dev/sda";
            content = {
              # GPT works fine with legacy BIOS as long as we have a BIOS
              # boot partition (EF02) for GRUB to embed its core image into.
              type = "gpt";
              partitions = {
                # GRUB core image lives here — no filesystem, raw partition
                bios_boot = {
                  size = "1M";
                  type = "EF02";
                  priority = 1; # must be first on disk
                };
                # Unencrypted /boot so GRUB can read kernel + initrd before
                # unlocking LUKS. Keep this outside the LUKS container.
                boot = {
                  size = "512M";
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/boot";
                  };
                };
                luks = {
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "crypted";
                    settings = {
                      allowDiscards = true;
                    };
                    content = {
                      type = "btrfs";
                      extraArgs = [ "-f" ];
                      subvolumes = {
                        "/root" = {
                          mountpoint = "/";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "/home" = {
                          mountpoint = "/home";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "/nix" = {
                          mountpoint = "/nix";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "/swap" = {
                          mountpoint = "/.swapvol";
                          swap.swapfile.size = "4G";
                        };
                      };
                    };
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
