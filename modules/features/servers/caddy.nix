{
  flake.nixosModules.sharedCaddy = {
    config = {
      services.caddy = {
        enable = true;
        extraConfig = ''
          nagato.taila32e5.ts.net {
              root * /var/www
              file_server
          }
          *.nagato.local {
              tls internal
          }
          glance.nagato.local {
              reverse_proxy http://localhost:8080
          }
          vault.nagato.local {
              reverse_proxy http://localhost:8222
          }
        '';
      };
      services.tailscale.permitCertUid = "caddy";
    };
  };
}
