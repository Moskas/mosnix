{
  config,
  lib,
  pkgs,
  ...
}:
{
  flake.nixosModules.awesome = {
    config = {
      services.xserver.windowManager.awesome = {
        enable = true;
      };
    };
  };
}
