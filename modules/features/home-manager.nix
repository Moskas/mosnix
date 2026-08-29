{ inputs, ... }:
{
  flake.nixosModules.moskasHomeManager = {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      users."moskas" = {
        home = {
          username = "moskas";
          homeDirectory = "/home/moskas";
          stateVersion = "26.05";
        };
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

}
