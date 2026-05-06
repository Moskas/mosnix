{
  flake.nixosModules.cheshire =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {

      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [
        "kvm-amd"
        "i2c-dev"
        "i2c-piix4"
      ];
      boot.extraModulePackages = [ ];
      boot.extraModprobeConfig = "options kvm_amd nested=1";

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/d6f3d80f-10c7-411c-a1b1-dc6643d7c1e4";
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/d6f3d80f-10c7-411c-a1b1-dc6643d7c1e4";
        fsType = "btrfs";
        options = [ "subvol=home" ];
      };

      fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/d6f3d80f-10c7-411c-a1b1-dc6643d7c1e4";
        fsType = "btrfs";
        options = [ "subvol=nix" ];
      };

      fileSystems."/media/Data" = {
        device = "/dev/disk/by-uuid/21047625-3f94-48ae-bac3-dc166b7b385f";
        fsType = "btrfs";
      };

      fileSystems."/media/Games" = {
        device = "/dev/disk/by-label/Gry";
        fsType = "ntfs";
      };

      fileSystems."/media/GamesII" = {
        device = "/dev/disk/by-uuid/26AD824F14FB66CD";
        fsType = "ntfs";
      };

      fileSystems."/boot-windows" = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NS0T120398J-part1";
        fsType = "vfat";
      };

      fileSystems."/media/Win11" = {
        device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S6P7NS0T120398J-part3";
        fsType = "ntfs";
      };

      fileSystems."/media/Laffey" = {
        device = "moskas@laffey:/home/moskas";
        fsType = "sshfs";
        options = [
          "nodev"
          "noatime"
          "allow_other"
          "default_permissions"
          "IdentityFile=/home/moskas/.ssh/cheshire"
          "_netdev"
          "nofail"
          "ServerAliveInterval=15"
          "ServerAliveCountMax=3"
        ];
      };

      fileSystems."/media/Shared" = {
        device = "moskas@laffey:/mnt/disk2";
        fsType = "sshfs";
        options = [
          "nodev"
          "noatime"
          "allow_other"
          "default_permissions"
          "IdentityFile=/home/moskas/.ssh/cheshire"
          "_netdev"
          "nofail"
          "ServerAliveInterval=15"
          "ServerAliveCountMax=3"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/DDA7-8FC1";
        fsType = "vfat";
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/d16c2fc6-991e-4866-8081-9b61333c94dd"; } ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
