{ self, ... }:
let
  homeModule = {
    imports = with self.homeModules; [
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
in {
  flake.nixosModules.profile-terminal = {
    home-manager.users."moskas".imports = [ homeModule ];
  };

  flake.homeModules.profile-terminal = homeModule;
}
