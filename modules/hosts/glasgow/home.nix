{ self, inputs, ... }:
{
  flake.homeConfigurations.glasgow = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = self.lib.moskas.homePkgs;
    modules = [
      self.homeModules.standalone-base
      self.homeModules.graphical
      { moskas.desktop.bar.position = "bottom"; }
    ];
  };
}
