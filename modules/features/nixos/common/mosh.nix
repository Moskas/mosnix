{
  flake.nixosModules.common = {
    config = {
      programs.mosh.enable = true;
    };
  };
}
