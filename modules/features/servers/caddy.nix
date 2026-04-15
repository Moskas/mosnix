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
        '';
      };
      services.tailscale.permitCertUid = "caddy";
    };
  };
}
