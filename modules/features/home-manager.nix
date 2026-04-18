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

  flake.nixosModules.minimalHome = {
    config = {
      home-manager.users."moskas".imports = with self.homeModules; [
        atuin
        bat
        btop
        git
        ranger
        starship
        zoxide
        zsh
      ];
    };
  };

  flake.nixosModules.fullHome = {
    config = {
      home-manager.users."moskas".imports = with self.homeModules; [
        atuin
        bat
        btop
        claude
        direnv
        emacs
        fuzzel
        firefox
        git
        kitty
        noctalia
        opencode
        ranger
        starship
        wallpapers
        zoxide
        zsh
      ];
    };
  };
}
