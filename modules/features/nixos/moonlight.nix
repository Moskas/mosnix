{
  flake.nixosModules.moonlight = {
    config = {
      programs.moonlight-qt = {
        enable = true;
        capSysNice = true;
      };
    };
  };
}
