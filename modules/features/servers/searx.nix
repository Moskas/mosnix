{
  flake.nixosModules.searx = {
    config = {
      services.searx = {
        enable = true;
        settings = {
          server = {
            port = "8192";
            bind_address = "0.0.0.0";
            secret_key = "hahayes"; # TODO Add sops
          };
        };
      };
    };
  };
}
