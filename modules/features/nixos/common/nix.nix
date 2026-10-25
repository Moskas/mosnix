{
  inputs,
  lib,
  self,
  ...
}:
{
  flake.nixosModules.common =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.moskasOverlays
        self.nixosModules.caches
        inputs.nix-index-database.nixosModules.default
      ];

      environment.systemPackages = with pkgs; [
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
        package = pkgs.lixPackageSets.latest.lix;
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
        };
      };

      programs.nh = {
        enable = true;
        flake = "/home/moskas/Repos/dendritic-nix/";
      };

      programs.nix-ld = {
        enable = true;
      };

      # programs.nix-index = {
      #  enable = true;
      #  enableBashIntegration = true;
      #  enableZshIntegration = true;
      #};

      programs.nix-index-database.comma.enable = true;

      environment.sessionVariables = {
        NIX_SSHOPS = "-tt";
      };

      nixpkgs.config.allowUnfree = true;
    };

  # Shared so moskasHomeManager can pull the overlays in for hosts that don't import
  # `common` (e.g. the WSL host). Stable key dedups when both are imported.
  flake.nixosModules.moskasOverlays = {
    key = "moskas/overlays";
    nixpkgs.overlays = [
      inputs.mospkgs.overlays.default
      inputs.emacs-overlay.overlay
      inputs.llm-agents.overlays.shared-nixpkgs
    ];
  };
}
