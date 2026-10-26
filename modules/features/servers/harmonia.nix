{
  # Binary cache serving laffey's own /nix/store, reached via the tsnsrv
  # `cache` node. Hosts pick it up through the substituter in `common`.
  flake.nixosModules.harmonia =
    { config, ... }:
    {
      config = {
        # Secret half of cache.taila32e5.ts.net-1, read via systemd LoadCredential
        sops.secrets.harmonia_signing_key = {
          mode = "0400";
        };

        services.harmonia.cache = {
          enable = true;
          signKeyPaths = [ config.sops.secrets.harmonia_signing_key.path ];
          settings = {
            bind = "127.0.0.1:5000";
            # Queried after cache.nixos.org (40), so upstream paths come from upstream
            priority = 50;
          };
        };
      };
    };
}
