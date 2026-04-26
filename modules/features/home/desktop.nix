{ lib, ... }:
{
  flake.homeModules.moskasDesktop = {
    options.moskas = {
      desktop = {
        bar = {
          position = lib.mkOption {
            type = lib.types.str;
            default = "top";
            description = "Default desktop bar position";
          };
        };
      };
    };
  };
}
