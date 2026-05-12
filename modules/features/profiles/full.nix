{ self, ... }:
let
  homeModule = {
    imports = with self.homeModules; [
      niri
      noctalia
      kitty
      fuzzel
      wallpapers
    ];
    programs.niri.settings.spawn-at-startup = [
      { sh = "noctalia-shell"; }
    ];
  };
in {
  flake.nixosModules.profile-full = {
    imports = [
      self.nixosModules.niri
      self.nixosModules.ly
    ];
    home-manager.users."moskas".imports = [ homeModule ];
  };

  flake.homeModules.profile-full = homeModule;
}
