{ inputs, ... }:
{
  # Per-service Tailscale identities: each entry below registers its own tailnet
  # node (flat MagicDNS name, e.g. vault.taila32e5.ts.net) with its own
  # auto-renewed TLS cert, proxying to a service bound on laffey's localhost.
  # No inbound firewall ports are needed - tsnsrv nodes dial out over tailscale.
  flake.nixosModules.tsnsrvProxy =
    { config, ... }:
    {
      imports = [ inputs.tsnsrv.nixosModules.default ];
      config = {
        services.tsnsrv = {
          enable = true;
          defaults = {
            authKeyPath = config.sops.secrets.tsnsrv_authkey.path;
            # Keep stable node identities / tailnet IPs across restarts.
            ephemeral = false;
          };
          services = {
            vault.toURL = "http://127.0.0.1:8222";
            n8n.toURL = "http://127.0.0.1:5678";
            jellyfin.toURL = "http://127.0.0.1:8096";
            deluge.toURL = "http://127.0.0.1:8112";
            git.toURL = "http://127.0.0.1:3000";
          };
        };
      };
    };
}
