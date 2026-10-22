{ inputs, ... }:
let
  # Data disks predate disko and carry no GPT partlabel, so their partitions
  # are pinned by filesystem UUID instead of disko's by-partlabel default.
  dataDisk = id: uuid: mountpoint: {
    device = "/dev/disk/by-id/${id}";
    type = "disk";
    content = {
      type = "gpt";
      partitions.data = {
        size = "100%";
        device = "/dev/disk/by-uuid/${uuid}";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          inherit mountpoint;
          # Don't drop the headless box into emergency mode over a data disk
          mountOptions = [ "nofail" ];
        };
      };
    };
  };
in
{
  flake.nixosModules.laffey = {
    imports = [
      inputs.disko.nixosModules.default
    ];
    config = {
      disko.devices = {
        disk = {
          # Key stays `vda`: it's baked into the existing partlabels (disk-vda-*)
          vda = {
            device = "/dev/disk/by-id/ata-WDC_WD10EZEX-75M2NA0_WD-WCC3F0TA2AEP";
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
                  };
                };
              };
            };
          };
          disk1 =
            dataDisk "ata-ST1000DM003-1CH162_S1D6V7LN" "a53f555f-3b89-400c-befa-3c07e085490b"
              "/mnt/disk1";
          disk2 =
            dataDisk "ata-ST1000LM014-SSHD-8GB_W772P8Q1" "c9535a3b-48b3-4a5c-8c36-704890c76905"
              "/mnt/disk2";
        };
      };
    };
  };
}
