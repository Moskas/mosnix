{ self, inputs, ... }:

{
  flake.nixosConfigurations.nagato = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nagato
    ];
  };
  flake.nixosModules.nagato =
    { pkgs, lib, ... }:
    {
      imports = [
        self.nixosModules.common
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "nagato";

      networking = {
        networkmanager.enable = true;
        firewall = {
          enable = true;
          allowedTCPPorts = [
            8192
          ];
        };
      };

      # Set your time zone.
      time.timeZone = "Europe/Warsaw";

      environment.systemPackages = with pkgs; [
        neovim
        git
      ];
      programs.nano.enable = false;

      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
