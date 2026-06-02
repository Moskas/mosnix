{ inputs, self, ... }:
{
  flake.nixosModules.moskasHomeManager = {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    nixpkgs.overlays = [
      inputs.emacs-overlay.overlay
      inputs.llm-agents.overlays.default
    ];

    home-manager = {
      users."moskas" = {
        home = {
          username = "moskas";
          homeDirectory = "/home/moskas";
          stateVersion = "25.11";
        };
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

}
