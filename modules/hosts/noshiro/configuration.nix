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
      self.nixosModules.commonWorkstation
      self.nixosModules.laptop
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.moskasProfile
      self.nixosModules.vm-test
    ];

    moskas.profile = "full";
    moskas.colorscheme = "solarized-dark";

    networking.hostName = "noshiro";
  };
}
