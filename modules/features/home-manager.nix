{ inputs, ... }:
{

  flake.nixosModules.moskasHomeManager = {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

}
