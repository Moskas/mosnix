{ inputs, ... }:
{

  flake.nixosModules.nagato = {
    imports = [
      inputs.disko.nixosModules.default
    ];
    config = {
      disko.devices = {
        disk = {
          vda = {
            device = "/dev/mmcblk0";
            type = "disk";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  type = "EF00";
                  size = "500M";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                  };
                };
                root = {
                  size = "100%";
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/rootfs" = {
                        mountpoint = "/";
                      };
                      "/home" = {
                        mountOptions = [ "compress=zstd" ];
                        mountpoint = "/home";
                      };
                      "/nix" = {
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                        mountpoint = "/nix";
                      };
                      "/media" = {
                        mountpoint = "/media";
                        mountOptions = [ "compress=zstd" ];
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
