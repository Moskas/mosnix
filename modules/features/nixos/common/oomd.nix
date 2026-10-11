{
  flake.nixosModules.common = {
    config = {
      systemd.oomd = {
        enable = true;
        enableUserSlices = true;
        enableRootSlice = true;
        settings.OOM = {
          SwapUsedLimit = "30%";
          SwapHogLimit = "20%";
          SwapPreHogLimit = "5%";
        };
      };
    };
  };
}
