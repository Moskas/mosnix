{ self, inputs, lib, ... }:

{
  flake.nixosConfigurations.kasumi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.kasumi
    ];
  };
  flake.nixosModules.kasumi =
    { pkgs, ... }:
    {
      imports = with self.nixosModules; [
        common
        commonServer
        moskasProfile
        sops
        kojin
      ];

      moskas.profile = "terminal";

      networking.hostName = "kasumi";

      # The box booted BIOS (no /sys/firmware/efi, sda14 is a BIOS boot
      # partition) despite an unused ESP at sda15 — a Hetzner legacy-boot
      # image, not UEFI. Reconcile against nixos-infect's actual output.
      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
        grub = {
          enable = true;
          device = "/dev/sda";
          efiSupport = false;
        };
      };

      # Xanmod buys nothing on a headless web server and adds boot risk on a
      # remote box; common.nix's boot.nix sets it via mkDefault for this.
      boot.kernelPackages = pkgs.linuxPackages;

      environment.systemPackages = with pkgs; [
        neovim
        git
      ];

      programs.nano.enable = false;
    };
}
