{
  flake.homeModules.zathura = {
    config = {
      programs.zathura = {
        enable = true;
        options = {
          guioptions = "";
        };
      };
    };
  };
}
