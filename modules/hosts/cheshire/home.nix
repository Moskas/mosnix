{
  self,
  inputs,
  ...
}:
{

  flake.homeConfigurations.moskas = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.moskasModule
      self.homeModules.profile-full
      self.homeModules.obs
    ];
  };

  flake.homeModules.moskasModule = {
    config = {
      moskas.obs.cuda = true;
    };
  };

}
