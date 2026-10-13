{ inputs, ... }:
{
  flake.nixosModules.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    config = {
      sops = {
        defaultSopsFile = ./secrets.yaml;
        defaultSopsFormat = "yaml";

        age = {
          generateKey = true;
          keyFile = "/var/lib/sops-nix/key.txt";
        };

        secrets = {
          laffey_runner = {
            mode = "0400";
          };

          # Reusable, non-ephemeral, pre-approved, tagged tailscale auth key
          # used by tsnsrv to register each per-service node. Read as root via
          # systemd LoadCredential, so default owner/mode is fine.
          tsnsrv_authkey = {
            mode = "0400";
          };

          attic_token = {
            mode = "0400";
          };
          kojin_env_file = {
            mode = "0400";
          };
        };
      };
    };
  };
}
