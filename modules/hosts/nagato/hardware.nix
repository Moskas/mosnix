{
  flake.nixosModules.nagato =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];
      config = {
        boot.initrd.availableKernelModules = [
          "xhci_pci"
          "usb_storage"
          "usbhid"
          "sd_mod"
          "sdhci_pci"
          "sdhci_acpi"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        # fileSystems."/" = {
        #   device = "/dev/disk/by-uuid/56fd5485-2980-4242-9e1f-c9674d99ebe8";
        #   fsType = "btrfs";
        # };

        # fileSystems."/boot" = {
        #   device = "/dev/disk/by-uuid/E773-9C02";
        #   fsType = "vfat";
        #   options = [
        #     "fmask=0022"
        #     "dmask=0022"
        #   ];
        # };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
}
