{ self, inputs, ... }:
{
  flake.homeConfigurations.akashi = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.moskas.homePkgs;
    modules = [
      self.homeModules.standalone-base
      self.homeModules.terminal
    ];
  };
}
