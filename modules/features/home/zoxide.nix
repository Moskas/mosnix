{
  flake.homeModules.zoxide =
    { lib, config, ... }:
    {
      config = {
        programs.zoxide = {
          enable = true;
          enableZshIntegration = lib.mkIf config.programs.zsh.enable true;
        };
      };
    };
}
