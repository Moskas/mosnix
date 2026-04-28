{
  flake.homeModules.eza =
    { lib, config, ... }:
    {
      config = {
        programs.eza = {
          enable = true;
          enableZshIntegration = lib.mkIf config.programs.zsh.enable true;
          enableBashIntegration = true;
          icons = "auto";
          git = true;
        };
      };
    };
}
