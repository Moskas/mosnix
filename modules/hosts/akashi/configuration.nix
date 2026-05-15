{ self, inputs, ... }:

{
  flake.nixosConfigurations.akashi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.akashi
    ];
  };
  flake.nixosModules.akashi = {
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

    networking = {
      hostName = "akashi";
    };

  };
}
