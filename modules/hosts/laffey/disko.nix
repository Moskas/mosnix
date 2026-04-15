{ inputs, ... }:
{
  flake.nixosModules.laffey = {
    imports = [
      inputs.disko.nixosModules.default
    ];
    config = {
      disko.devices = {
        disk = {
          sda = {
            device = "/dev/sda";
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
                      "/swap" = {
                        mountpoint = "/.swapvol";
                        swap = {
                          swapfile.size = "8G";
                        };
                      };
                      "/media" = {
                        mountpoint = "/media";
                        mountOptions = [ "compress=zstd" ];
                      };
                    };
                    mountpoint = "/partition-root";
                    swap = {
                      swapfile = {
                        size = "8G";
                      };
                    };
                  };
                };
              };
            };
          };
          # sshd = {
          #   device = "/dev/sdc";
          #   type = "disk";
          #   content = {
          #     type = "gpt";
          #     root = {
          #       size = "100%";
          #       content = {
          #         type = "btrfs";
          #         extraArgs = [ "-f" ];
          #         subvolumes = {
          #           "/" = {
          #             mountpoint = "/";
          #             mountOptions = [ "compress=zstd" ];
          #           };
          #           mountpoint = "/mnt/disk2";
          #         };
          #       };
          #     };
          #   };
          # };
        };
      };
    };
  };
}
