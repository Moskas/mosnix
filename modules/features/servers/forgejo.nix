{
  flake.nixosModules.forgejo =
    { pkgs, config, ... }:
    {
      config = {
        services.forgejo = {
          enable = true;
          package = pkgs.forgejo;
          settings = {
            server = {
              DOMAIN = "git.taila32e5.ts.net";
              ROOT_URL = "https://git.taila32e5.ts.net/";
              HTTP_ADDR = "127.0.0.1";
              HTTP_PORT = 3000;
              # git-over-SSH does not pass through tsnsrv; use the real host node.
              SSH_DOMAIN = "${config.networking.hostName}.taila32e5.ts.net";
            };
            actions = {
              ENABLED = true;
              DEFAULT_ACTIONS_URL = "github";
            };
          };
        };
        # Actions runner disabled until a container runtime is chosen deliberately.
        # Its docker:// labels require podman/docker on the host, and the NixOS
        # assertion fires even when the instance is `enable = false`. To turn it
        # back on: enable virtualisation.podman and restore this block.
        #
        # services.gitea-actions-runner = {
        #   package = pkgs.forgejo-runner;
        #   instances.default = {
        #     enable = true;
        #     name = "${config.networking.hostName}";
        #     tokenFile = config.sops.secrets.laffey_runner.path;
        #     url = "http://127.0.0.1:3000/";
        #     labels = [
        #       "ubuntu-latest:docker://node:20-bookworm"
        #       "ubuntu-22.04:docker://node:20-bookworm"
        #       "nixos-latest:docker://nixos/nix"
        #       "native:host"
        #     ];
        #   };
        # };
      };
    };
}
