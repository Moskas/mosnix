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
    ];
  };

  flake.homeModules.moskasModule =
    { pkgs, ... }:
    {
      programs.bash.enable = true;
      programs.bash.shellAliases.ll = "ls -l";

      home.packages = [ pkgs.hello ];
      home.stateVersion = "24.11";
    };

}
