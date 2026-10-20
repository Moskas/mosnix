{
  flake.homeModules.direnv = {
    config = {
      programs.direnv = {
        enable = true;
        silent = true;
        enableZshIntegration = true;
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
