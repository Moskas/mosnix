{
  flake.nixosModules.qtile =
    { pkgs, ... }:
    {
      config = {
        services.xserver.windowManager.qtile = {
          enable = true;
          package = pkgs.python314Packages.qtile;
          extraPackages =
            python3Packages: with python3Packages; [
              iwlib
            ];
        };
      };
    };
}
