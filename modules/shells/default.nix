{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      devshells.default = {
        name = "Moskas flake devshell";

        packages = with pkgs; [
          nixfmt
          nixos-generators
          git
          sops
          age
          deadnix
          nixd
          statix
          cachix
          attic-client
          disko
        ];

        commands = [
          {
            name = "deploy";
            help = "Deploy nixos configuration to host";
            command = ''
              host="''${1:-}"

              if [ -z "$host" ]; then
                echo "Usage: deploy <hostname>"
                exit 1
              fi

              exec nixos-rebuild switch \
                --flake ".#$host" \
                --target-host "$host" \
                --ask-sudo-password
            '';
          }
        ];

        env = [
          {
            name = "NIX_CONFIG";
            value = "extra-experimental-features = nix-command flakes";
          }

          {
            name = "FLAKE";
            value = "$(pwd)";
          }

          {
            name = "NH_FLAKE";
            value = "$(pwd)";
          }

          {
            name = "DIRENV_LOG_FORMAT";
            value = "";
          }
        ];
      };
    };
}
