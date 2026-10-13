{ self, inputs, ... }:
{
  flake.homeConfigurations.nagato = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.moskas.homePkgs;
    modules = [
      self.homeModules.standalone-base
      self.homeModules.terminal
    ];
  };
}
