{ inputs, lib, ... }:
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
                --use-remote-sudo \
                --ask-sudo-password
            '';
          }
          {
            name = "vm";
            help = "Build a test-vm for a given hostname";
            command = ''
              host="''${1:-}"

              if [ -z "$host" ]; then
                echo "Usage: vm <hostname>"
                exit 1
              fi

              rm -f -- *.qcow2 # For clean filesystem
              nixos-rebuild build-vm --flake .#"$host"
              ./result/bin/run-"$host"-vm
            '';
          }
          {
            name = "update-wallpapers";
            help = "Bump wallpapers rev and per-theme hashes";
            command = ''
              pin="$PRJ_ROOT/modules/features/home/wallpapers.json"
              url="https://github.com/Moskas/wallpapers"

              rev=$(${lib.getExe pkgs.git} ls-remote "$url" main | cut -f1)
              if [ "$rev" = "$(${lib.getExe pkgs.jq} -r .rev "$pin")" ]; then
                echo "wallpapers already at $rev"
                exit 0
              fi

              new=$(${lib.getExe pkgs.jq} --arg rev "$rev" '.rev = $rev' "$pin")
              for theme in $(${lib.getExe pkgs.jq} -r '.hashes | keys[]' "$pin"); do
                echo "prefetching $theme @ $rev"
                hash=$(${lib.getExe pkgs.nix-prefetch-git} --quiet \
                  --url "$url" --rev "$rev" --sparse-checkout "$theme" \
                  | ${lib.getExe pkgs.jq} -r .hash)
                new=$(echo "$new" | ${lib.getExe pkgs.jq} --arg t "$theme" --arg h "$hash" \
                  '.hashes[$t] = $h')
              done

              echo "$new" > "$pin"
              echo "wallpapers bumped to $rev"
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
            eval = "$PRJ_ROOT";
          }

          {
            name = "NH_FLAKE";
            eval = "$PRJ_ROOT";
          }

          {
            name = "DIRENV_LOG_FORMAT";
            value = "";
          }
        ];
      };
    };
}
