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
        eza
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
        eza
        fuzzel
        firefox
        git
        kitty
        niri
        nixcord
        noctalia
        opencode
        prism
        ranger
        starship
        wallpapers
        zoxide
        zsh
      ];
    };
  };
}
