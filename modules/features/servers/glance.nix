{
  flake.nixosModules.sharedGlance = {
    config = {
      services.glance = {
        enable = true;
      };
    };
  };
}
