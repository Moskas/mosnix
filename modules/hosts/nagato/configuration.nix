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
        self.nixosModules.niri
        self.nixosModules.ly
        self.nixosModules.moskasHomeManager
        self.nixosModules.fullHome
      ];

      networking.hostName = "nagato";

      environment.systemPackages = with pkgs; [
        neovim
        git
      ];

      programs.nano.enable = false;

      system.stateVersion = "25.11"; # Did you read the comment?

    };
}
