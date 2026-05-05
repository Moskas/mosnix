{
  flake.nixosModules.miniflux = {
    config = {
      services.miniflux = {
        enable = true;
        adminCredentialsFile = "/etc/miniflux.env";
      };
    };
  };
}
