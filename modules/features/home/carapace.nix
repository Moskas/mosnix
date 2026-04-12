{
  flake.homeModules.carapace =
    { lib, config, ... }:
    {
      config = {
        programs.carapace = {
          enable = true;
          enableZshIntegration = lib.mkIf config.programs.zsh.enable true;
        };
      };
    };
}
