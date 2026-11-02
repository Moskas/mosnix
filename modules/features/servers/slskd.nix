{
  flake.nixosModules.slskd =
    { config, ... }:
    {
      config = {
        # SLSKD_SLSK_USERNAME/PASSWORD and SLSKD_USERNAME/PASSWORD
        sops.secrets.slskd_env = {
          mode = "0400";
        };
        services.slskd = {
          enable = true;
          # Web UI reached via the tsnsrv `slskd` node, so no nginx vhost
          domain = null;
          # Opens the soulseek peer port only, not the web UI
          openFirewall = true;
          environmentFile = config.sops.secrets.slskd_env.path;
          settings.shares.directories = [ "/media/music" ];
        };
        # The share dir must exist, systemd refuses to start the unit when a
        # ReadOnlyPaths target is missing
        systemd.tmpfiles.rules = [ "d /media/music - - - -" ];
        # .NET 10.0.14 keeps named mutexes under $XDG_RUNTIME_DIR, falling back to
        # $HOME (/var/empty, read-only), so slskd exits on the singleton mutex
        systemd.services.slskd = {
          environment.XDG_RUNTIME_DIR = "/run/slskd";
          serviceConfig.RuntimeDirectory = "slskd";
        };
      };
    };
}
