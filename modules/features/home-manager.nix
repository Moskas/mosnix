{ inputs, self, ... }:
{

  flake.nixosModules.moskasHomeManager = {
    imports = [
      inputs.home-manager.nixosModules.default
    ];

    home-manager = {
      users."moskas".home = {
        username = "moskas";
        homeDirectory = "/home/moskas";
      };
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };

  flake.nixosModules.minimalHome = {
    modules = with self.homeModules; [
      btop
      git
      starship
      zsh
    ];
  };

  flake.nixosModules.fullHome = {
    modules = with self.homeModules; [
      bat
      btop
      direnv
      emacs
      git
      opencode
      starship
      zsh
    ];
  };
}
