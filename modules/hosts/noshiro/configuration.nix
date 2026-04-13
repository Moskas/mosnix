{ self, inputs, ... }:

{
  flake.nixosConfigurations.noshiro = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.noshiro
    ];
  };
  flake.nixosModules.noshiro = {
    imports = [
      self.nixosModules.common
      self.nixosModules.niri
      self.nixosModules.ly
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.moskasHomeManager
      self.nixosModules.fullHome
    ];

    moskas.colorscheme = "solarized-dark";

    networking.hostName = "noshiro";

    system.stateVersion = "25.11";

  };
}
