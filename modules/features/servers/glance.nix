{
  flake.nixosModules.glance = {
    config = {
      services.glance = {
        enable = true;
      };
    };
  };
}
