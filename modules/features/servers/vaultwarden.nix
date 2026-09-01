{
  flake.nixosModules.vaultwarden = {
    config = {
      services.vaultwarden = {
        enable = true;
        backupDir = "/var/local/vaultwarden/backup";
        config = {
          DOMAIN = "https://vault.taila32e5.ts.net";
          SIGNUPS_ALLOWED = true;
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          ROCKET_LOG = "critical";
        };
      };
    };
  };
}
