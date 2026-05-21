{ self, inputs, ... }:

{
  flake.nixosConfigurations.akashi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.akashi
    ];
  };
  flake.nixosModules.akashi =
    { lib, ... }:
    {
      imports = [
        self.nixosModules.common
        self.nixosModules.commonWorkstation
        self.nixosModules.laptop
        #self.nixosModules.niri
        #self.nixosModules.ly
        #inputs.stylix.nixosModules.stylix
        #self.nixosModules.stylixConfig
        #self.nixosModules.moskasHomeManager
        #self.nixosModules.fullHome
        self.nixosModules.japanese-input
      ];

      networking.hostName = "akashi";

      # ThinkPad X60 — legacy BIOS only, no UEFI
      # Override the systemd-boot defaults from the common module.
      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = lib.mkForce false;
        grub = {
          enable = true;
          # Install GRUB to the MBR of the disk (not a partition)
          device = "/dev/sda";
          # Prompt for the LUKS passphrase inside GRUB so it can read /boot
          enableCryptodisk = true;
        };
      };
    };
}
