{
  flake.homeModules.bat = {
    config = {
      home.sessionVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        MANROFFOPT = "-c";
      };

      programs.bat = {
        enable = true;
        config = {
          color = "always";
          pager = "less -FR";
        };
      };
    };
  };
}
