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
              DOMAIN = "git.${config.networking.hostName}";
              ROOT_URL = "http://git.${config.networking.hostName}.local/";
            };
            actions = {
              ENABLED = true;
              DEFAULT_ACTIONS_URL = "github";
            };
          };
        };
        services.gitea-actions-runner = {
          package = pkgs.forgejo-runner;
          instances.default = {
            enable = true;
            name = "${config.networking.hostName}";
            tokenFile = config.sops.secrets.forgejo_runner.path;
            url = "http://git.${config.networking.hostName}.local/";
            labels = [
              "ubuntu-latest:docker://node:20-bookworm"
              "ubuntu-22.04:docker://node:20-bookworm"
              "nixos-latest:docker://nixos/nix"
              "native:host"
            ];
          };
        };
      };
    };
}
