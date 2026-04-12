{
  flake.homeModules =
    { lib, config, ... }:
    {
      config = {
        programs.direnv = {
          enable = true;
          silent = true;
          enableZshIntegration = lib.mkIf config.programs.zsh.enable true;
          nix-direnv.enable = true;
          config = {
            global = {
              disable_stdin = true;
              whitelist = {
                prefix = [
                  "~/Repos"
                  "~/Projects"
                ];
              };
            };
          };
        };
      };
    };
}
