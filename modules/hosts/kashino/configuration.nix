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

    home-manager.users."moskas".programs.niri.settings.outputs = {
      "LG Display 0x0521 Unknown" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.020;
        };
        scale = 1.1;
        transform = {
          rotation = 0;
          flipped = false;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      "Dell Inc. DELL P2319H J19FY83" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 59.940;
        };
        position = {
          x = -88;
          y = -1080;
        };
        scale = 1.0;
      };
      "DP-4" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.000;
        };
        scale = 1;
        enable = false;
      };
      "DP-7" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.000;
        };
        scale = 1;
        enable = false;
      };
    };

  };
}
