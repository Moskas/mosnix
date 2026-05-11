{ self, inputs, ... }:

{
  flake.nixosConfigurations.akashi = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.akashi
    ];
  };
  flake.nixosModules.akashi =
    { pkgs, ... }:
    {
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
      ];

      networking = {
        hostName = "akashi";
      };

      services.xserver = {
        xkb = {
          layout = "jp";
          options = "lv3:ralt_switch";
        };
      };

      i18n.inputMethod = {
        enable = true;
        type = "ibus";
        ibus.engines = with pkgs.ibus-engines; [ mozc-ut ];
      };

    };
}
