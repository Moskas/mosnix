{
  flake.nixosModules.common = {
    config = {
      services.fstrim.enable = true;
    };
  };
}
