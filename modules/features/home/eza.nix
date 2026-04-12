{
  flake.homeModules.eza =
    { lib, config, ... }:
    {
      config = {
        programs.eza = {
          enable = true;
          enablezshintegration = lib.mkIf config.programs.zsh.enable true;
          enablebashintegration = true;
          icons = "auto";
          git = true;
        };
      };
    };
}
