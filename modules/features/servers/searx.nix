{
  flake.nixosModules.searx =
    { config, ... }:
    {
      config = {
        # Env file content is the literal line `SEARX_SECRET_KEY=...`; the
        # searx module envsubst's it into settings.yml at service start.
        sops.secrets.searx_env_file = {
          mode = "0400";
        };

        services.searx = {
          enable = true;
          environmentFile = config.sops.secrets.searx_env_file.path;
          settings = {
            server = {
              port = "8192";
              bind_address = "0.0.0.0";
              secret_key = "$SEARX_SECRET_KEY";
            };
          };
        };
      };
    };
}
