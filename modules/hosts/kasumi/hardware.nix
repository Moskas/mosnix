{
  flake.nixosModules.kasumi =
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
        # Placeholder: kasumi is installed via nixos-infect on an existing
        # Hetzner VPS, so this needs to be replaced with the real
        # fileSystems/initrd config from nixos-generate-config's output on
        # the live box after infecting, not hand-guessed ahead of time.
        boot.initrd.availableKernelModules = [
          "ata_piix"
          "uhci_hcd"
          "virtio_pci"
          "sd_mod"
          "sr_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        # fileSystems."/" = {
        #   device = "/dev/disk/by-uuid/REPLACE-ME";
        #   fsType = "ext4";
        # };

        # fileSystems."/boot/efi" = {
        #   device = "/dev/disk/by-uuid/REPLACE-ME";
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
