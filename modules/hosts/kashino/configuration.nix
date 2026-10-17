{ self, inputs, ... }:

{
  flake.nixosConfigurations.kashino = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.kashino
    ];
  };
  flake.nixosModules.kashino = {
    imports = [
      self.nixosModules.commonWorkstation
      self.nixosModules.laptop
      inputs.stylix.nixosModules.stylix
      self.nixosModules.stylixConfig
      self.nixosModules.graphical
      self.nixosModules.vm-test
      self.nixosModules.japanese-input
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-cpu-intel
    ];

    networking = {
      hostName = "kashino";
    };
  };
}
