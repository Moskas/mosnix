{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.common =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        #nix-tree
        #nixfmt
        #nixd
        #nix-inspect
        #nix-output-monitor
      ];

      nix.registry = lib.mapAttrs (_: value: {
        flake = value;
      }) inputs;

      nix = {
        package = pkgs.lixPackageSets.stable.lix;
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };

        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };

        sshServe = {
          enable = true;
          write = true;
        };

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          auto-optimise-store = true;
          builders-use-substitutes = true;
          use-xdg-base-directories = true;
          trusted-users = [
            "root"
            "moskas"
            "@wheel"
            "nix-ssh"
          ];

          warn-dirty = false;
          substituters = [
            "https://nix-community.cachix.org"
            "https://moskas.cachix.org"
            "https://cache.nixos.org/"
            "https://noctalia.cachix.org"
          ];

          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "moskas.cachix.org-1:LcyLityXMILC1SenFSMMt7JgvUEOvS38Kza6b96TQEw="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];

        };
      };

      programs.nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      environment.sessionVariables = {
        NIX_SSHOPS = "-tt";
        NH_FLAKE = "/home/moskas/Repos/new-flake";
      };

      nixpkgs = {
        overlays = [ inputs.mospkgs.overlays.default ];
        config = {
          allowUnfree = true;
        };
      };
    };
}
