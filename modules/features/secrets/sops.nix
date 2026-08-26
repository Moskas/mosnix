{
  flake.nixosModules.sops =
    { inputs, ... }:
    {
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
            ssh_host_ed25519_key = {
              owner = "root";
              mode = "0400";
              path = "/etc/ssh/ssh_host_ed25519_key";
            };

            authorized_keys = {
              owner = "root";
              mode = "0400";
            };

            laffey_runner = {
              mode = "0400";
            };

            attic_token = {
              mode = "0400";
            };
          };
        };
      };
    };
}
