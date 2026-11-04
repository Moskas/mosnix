{
  flake.nixosModules.common = {
    config = {
      zramSwap = {
        enable = true;
        algorithm = "zstd";
        # zstd compresses ~3x, so a full-size device still uses little real RAM
        memoryPercent = 100;
      };
      # prefer compressing idle anon pages over evicting page cache (e.g. /nix/store)
      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.page-cluster" = 0;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };
    };
  };
}
