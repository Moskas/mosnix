{ self, inputs, ... }:

{
  flake.nixosConfigurations.laffey = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.laffey
    ];
  };
  flake.nixosModules.laffey = {
    imports = with self.nixosModules; [
      common
      moskasProfile
      vm-test

      jellyfin
      deluge
    ];

    moskas.profile = "terminal";

    networking.hostName = "laffey";
  };
}
