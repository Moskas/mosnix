{ lib, ... }:
{
  flake.nixosModules.common-user =
    { lib, ... }:
    {
      options.preferences = {
        user.name = lib.mkOption {
          type = lib.types.str;
          default = "moskas";
        };
      };
    };

  flake.nixosModules.common-shell =
    { lib, ... }:
    {
      config = {
        programs.zsh.enable = true;
      };
    };
}
