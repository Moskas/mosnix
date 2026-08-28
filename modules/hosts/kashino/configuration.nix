{ self, inputs, ... }:

{
  flake.nixosConfigurations.kashino = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.kashino
    ];
  };
  flake.nixosModules.kashino = {
    imports = [
      self.nixosModules.common
      self.nixosModules.commonWorkstation
      self.nixosModules.laptop
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.moskasHomeManager
      self.nixosModules.profile-full
      self.nixosModules.vm-test
      self.nixosModules.japanese-input
    ];

    networking = {
      hostName = "kashino";
    };
  };
}
