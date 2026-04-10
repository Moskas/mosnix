{ self, inputs, ... }:
{

  flake.homeConfigurations.moskas = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.moskasModule
      {
        home.username = "moskas";
        home.homeDirectory = "/home/moskas";
      }
      self.homeModules.zsh
    ];
  };

  flake.homeModules.moskasModule = {
    home.stateVersion = "24.11";
  };

}
