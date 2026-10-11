{
  flake.homeModules.jj = {
    programs.jujutsu = {
      enable = true;
      settings.user = {
        name = "Moskas";
        email = "minemoskas@gmail.com";
      };
    };
  };
}
