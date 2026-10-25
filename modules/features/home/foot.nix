{
  flake.homeModules.foot = {
    config = {
      programs.foot = {
        enable = true;
        settings = {
          main.pad = "5x5";
          bell.system = "no";
        };
      };
    };
  };
}
