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
      moskasHomeManager
      profile-terminal
      vm-test

      jellyfin
      deluge
    ];

    networking.hostName = "laffey";
  };
}
