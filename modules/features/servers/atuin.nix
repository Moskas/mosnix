{
  flake.nixosModules.atuin = {
    config = {
      # Sync server for the `atuin` homeModule, reached via the tsnsrv `atuin`
      # node; listens on 127.0.0.1:8888 by default.
      services.atuin = {
        enable = true;
        openRegistration = false;
        openFirewall = false;
      };
    };
  };
}
