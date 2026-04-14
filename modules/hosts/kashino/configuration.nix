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
    ];

    networking = {
      hostName = "kashino";
    };

    services.xserver = {
      xkb = {
        layout = "jp";
        options = "lv3:ralt_switch";
      };
    };

  };
}
