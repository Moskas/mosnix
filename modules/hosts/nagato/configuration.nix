{ self, inputs, ... }:

{
  flake.nixosConfigurations.nagato = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.nagato
    ];
  };
  flake.nixosModules.nagato =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.common
        self.nixosModules.moskasHomeManager
        self.nixosModules.minimalHome
        self.nixosModules.sharedCaddy
        self.nixosModules.sharedGlance
      ];

      networking.hostName = "nagato";

      environment.systemPackages = with pkgs; [
        neovim
        git
      ];

      programs.nano.enable = false;

    };
}
