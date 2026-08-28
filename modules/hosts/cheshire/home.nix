{
  self,
  inputs,
  pkgs,
  ...
}:
{

  flake.homeConfigurations.moskas = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.moskasModule
      self.homeModules.profile-full
    ];
  };

  flake.homeModules.moskasModule = {
    config = {
      programs.obs-studio.package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
          pipewireSupport = true;
        }
      );
    };
  };

}
