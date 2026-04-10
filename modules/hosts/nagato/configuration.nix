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
