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
      nvidia
      sops
      tsnsrvProxy
      n8n
      vaultwarden
      jellyfin
      deluge
      forgejo
    ];

    moskas.profile = "terminal";

    networking.hostName = "laffey";
  };
}
