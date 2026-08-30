{ self, inputs, ... }:
{
  flake.homeConfigurations.kashino = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.moskas.homePkgs;
    modules = [
      self.homeModules.standalone-base
      self.homeModules.standalone-full
    ];
  };
}
