{
  self,
  inputs,
  ...
}:

{
  flake.nixosConfigurations.kasumi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.kasumi
    ];
  };

  flake.nixosModules.kasumi =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = with self.nixosModules; [
        commonServer
        terminal
        sops
        kojin
      ];

      networking.hostName = "kasumi";

      boot.loader = {
        systemd-boot.enable = lib.mkForce false;
        grub = {
          enable = true;
          efiSupport = false;
        };
      };

      boot.kernelPackages = pkgs.linuxPackages;

      # Only applies to `nixos-rebuild build-vm` (devshell `vm` command)
      virtualisation.vmVariant = {
        virtualisation.forwardPorts = [
          {
            from = "host";
            host.address = "127.0.0.1";
            host.port = 3000;
            guest.port = 3000;
          }
        ];
        networking.firewall.allowedTCPPorts = [ 3000 ];
      };

      environment.systemPackages = with pkgs; [
        neovim
        git
      ];

      programs.nano.enable = false;
    };
}
