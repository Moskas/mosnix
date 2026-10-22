{ inputs, ... }:
{
  # cheshire predates disko and dual-boots Windows, so its existing filesystems
  # are mirrored as mount-only `nodev` entries (disko never formats these).
  # A real partition layout for a future reinstall is sketched further down.
  flake.nixosModules.cheshire = {
    imports = [
      inputs.disko.nixosModules.default
    ];
    config = {
      disko.devices.nodev = {
        "/" = {
          device = "/dev/disk/by-uuid/d6f3d80f-10c7-411c-a1b1-dc6643d7c1e4";
          fsType = "btrfs";
          mountOptions = [ "subvol=root" ];
        };
        "/home" = {
          device = "/dev/disk/by-uuid/d6f3d80f-10c7-411c-a1b1-dc6643d7c1e4";
          fsType = "btrfs";
          mountOptions = [ "subvol=home" ];
        };
        "/nix" = {
          device = "/dev/disk/by-uuid/d6f3d80f-10c7-411c-a1b1-dc6643d7c1e4";
          fsType = "btrfs";
          mountOptions = [ "subvol=nix" ];
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/DDA7-8FC1";
          fsType = "vfat";
        };
        "/media/Data" = {
          device = "/dev/disk/by-uuid/21047625-3f94-48ae-bac3-dc166b7b385f";
          fsType = "btrfs";
        };
        "/media/Games" = {
          device = "/dev/disk/by-label/Gry";
          fsType = "ntfs";
        };
        "/media/GamesII" = {
          device = "/dev/disk/by-uuid/26AD824F14FB66CD";
          fsType = "ntfs";
        };
        "/boot-windows" = {
          device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NS0T120398J-part1";
          fsType = "vfat";
        };
        "/media/Win11" = {
          device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NS0T120398J-part3";
          fsType = "ntfs";
        };
      };
      # disko's swap type only exists as partition content; an existing swap
      # partition referenced by UUID has to stay a plain NixOS declaration.
      swapDevices = [ { device = "/dev/disk/by-uuid/d16c2fc6-991e-4866-8081-9b61333c94dd"; } ];
    };
  };

  #flake.nixosModules.cheshire = {
  #  imports = [
  #    inputs.disko.nixosModules.default
  #  ];
  #  config = {
  #    disko.devices = {
  #      disk = {
  #        main = {
  #          type = "disk";
  #          device = "/dev/nvme0n1";
  #          content = {
  #            type = "gpt";
  #            partitions = {
  #              ESP = {
  #                size = "1G";
  #                type = "EF00";
  #                content = {
  #                  type = "filesystem";
  #                  format = "vfat";
  #                  mountpoint = "/boot";
  #                  mountOptions = [ "umask=0077" ];
  #                };
  #              };
  #              luks = {
  #                size = "100%";
  #                content = {
  #                  type = "luks";
  #                  name = "crypted";
  #                  # disable settings.keyFile if you want to use interactive password entry
  #                  passwordFile = "/var/secret.key"; # Interactive
  #                  settings = {
  #                    allowDiscards = true;
  #                    #keyFile = "/tmp/secret.key";
  #                  };
  #                  #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
  #                  content = {
  #                    type = "btrfs";
  #                    extraArgs = [ "-f" ];
  #                    subvolumes = {
  #                      "/root" = {
  #                        mountpoint = "/";
  #                        mountOptions = [
  #                          "compress=zstd"
  #                          "noatime"
  #                        ];
  #                      };
  #                      "/home" = {
  #                        mountpoint = "/home";
  #                        mountOptions = [
  #                          "compress=zstd"
  #                          "noatime"
  #                        ];
  #                      };
  #                      "/nix" = {
  #                        mountpoint = "/nix";
  #                        mountOptions = [
  #                          "compress=zstd"
  #                          "noatime"
  #                        ];
  #                      };
  #                      "/swap" = {
  #                        mountpoint = "/.swapvol";
  #                        swap.swapfile.size = "16G";
  #                      };
  #                    };
  #                  };
  #                };
  #              };
  #            };
  #          };
  #        };
  #      };
  #    };
  #  };
  #};
}
