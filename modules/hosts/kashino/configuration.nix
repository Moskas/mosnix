{ self, inputs, ... }:

{
  flake.nixosConfigurations.kashino = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.kashino
    ];
  };
  flake.nixosModules.kashino =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.common
      ];

      networking = {
        hostName = "kashino";
      };

      console = {
        keyMap = "jp106";
      };

      services.xserver = {
        xkb = {
          layout = "jp";
          options = "lv3:ralt_switch";
        };
      };

      system.stateVersion = "24.11";
    };
}
