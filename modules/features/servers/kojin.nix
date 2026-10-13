{ inputs, ... }:
{
  flake.nixosModules.kojin =
    { config, lib, ... }:
    {
      imports = [ inputs.kojin.nixosModules.default ];

      services.kojin = {
        enable = true;
        siteUrl = "https://moskas.space";
        siteAuthor = "Moskas";
        environmentFile = config.sops.secrets.kojin_env_file.path;
      };

      systemd.services.kojin = {
        # The secret doesn't exist until the sops bootstrap pass (host age
        # key added, secrets.yaml re-encrypted) runs; upstream's
        # environmentFile has no `-` prefix, so a first boot before that
        # would hard-fail the unit instead of starting degraded.
        serviceConfig.EnvironmentFile = lib.mkForce "-${config.sops.secrets.kojin_env_file.path}";
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      security.acme = {
        acceptTerms = true;
        defaults.email = "CHANGEME@example.com"; # TODO: set the real ACME contact email
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        appendHttpConfig = ''
          limit_req_zone $binary_remote_addr zone=kojin_global:10m  rate=30r/s;
          limit_req_zone $binary_remote_addr zone=kojin_search:10m  rate=3r/s;
          limit_req_zone $binary_remote_addr zone=kojin_photos:10m  rate=5r/s;
          limit_req_zone $binary_remote_addr zone=kojin_img:10m     rate=10r/s;
        '';
        virtualHosts."moskas.space" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.kojin.port}";
            extraConfig = "limit_req zone=kojin_global burst=50 nodelay;";
          };
          locations."/search" = {
            proxyPass = "http://127.0.0.1:${toString config.services.kojin.port}";
            extraConfig = ''
              limit_req zone=kojin_search burst=5 nodelay;
              limit_req zone=kojin_global burst=50 nodelay;
            '';
          };
          locations."/photos" = {
            proxyPass = "http://127.0.0.1:${toString config.services.kojin.port}";
            extraConfig = ''
              limit_req zone=kojin_photos burst=5 nodelay;
              limit_req zone=kojin_global burst=50 nodelay;
            '';
          };
          locations."/photos/img/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.kojin.port}";
            extraConfig = ''
              limit_req zone=kojin_img burst=20 nodelay;
              limit_req zone=kojin_global burst=50 nodelay;
            '';
          };
        };
      };

      services.fail2ban = {
        enable = true;
        jails = {
          kojin-ratelimit.settings = {
            enabled = true;
            port = "http,https";
            filter = "kojin-ratelimit";
            logpath = "/var/log/nginx/access.log";
            maxretry = 10;
            findtime = 60;
            bantime = 3600;
          };
          nginx-botsearch.settings = {
            enabled = true;
            port = "http,https";
            filter = "nginx-botsearch";
            logpath = "/var/log/nginx/access.log";
            maxretry = 5;
            findtime = 60;
            bantime = 86400;
          };
        };
      };

      environment.etc."fail2ban/filter.d/kojin-ratelimit.conf".text = ''
        [Definition]
        failregex = ^<HOST> .* "(GET|POST|HEAD) .* HTTP/.*" 429
        ignoreregex =
      '';
    };
}
