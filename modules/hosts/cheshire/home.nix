{ self, inputs, ... }:
{
  flake.homeConfigurations.cheshire = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.moskas.homePkgs;
    modules = [
      self.homeModules.standalone-base
      self.homeModules.graphical
      self.homeModules.obs
    ];
  };
}
