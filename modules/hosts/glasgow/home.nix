{ self, inputs, ... }:
{

  flake.homeConfigurations.moskas = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.moskasModule
      self.homeModules.profile-full
    ];
  };

  flake.homeModules.moskasModule = {
    imports = [ self.homeModules.moskasOptions ];
    moskas.desktop.bar.position = "bottom";
  };

}
