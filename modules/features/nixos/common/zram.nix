{
  flake.nixosModules.common = {
    config = {
      zramSwap = {
        enable = true;
        algorithm = "zstd";
      };
    };
  };
}
