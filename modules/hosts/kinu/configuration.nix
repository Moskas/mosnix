{
  self,
  inputs,
  ...
}:

{
  flake.nixosConfigurations.kinu = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.kinu
    ];
  };
  flake.nixosModules.kinu =
    {
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        self.nixosModules.common
        "${modulesPath}/profiles/minimal.nix"
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "kinu";

      networking = {
        networkmanager.enable = true;
      };

      environment.systemPackages = with pkgs; [
        vim
      ];
      programs.nano.enable = false;

    };
}
