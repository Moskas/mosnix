{
  flake.homeModules.btop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.btop.package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.btop;
      };

      config = {
        programs.btop = {
          enable = true;
          package = config.btop.package;
          settings = {
            vim_keys = true;
            proc_sorting = "memory";
            rounded_corners = false;
          };
        };
      };
    };
}
