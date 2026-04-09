{ self, inputs, ... }:
{

  flake.nixosModules.moskasHomeManager =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.default
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

}
