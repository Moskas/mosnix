{ self, ... }:
let
  homeModule = {
    imports = with self.homeModules; [
      niri
      waybar
      mako
      kitty
      fuzzel
      wallpapers
    ];
    programs.niri.settings.spawn-at-startup = [
      { sh = "waybar"; }
      { sh = "mako"; }
    ];
  };
in
{
  flake.nixosModules.profile-lightweight = {
    imports = [
      self.nixosModules.niri
      self.nixosModules.ly
    ];
    home-manager.users."moskas".imports = [ homeModule ];
  };

  flake.homeModules.profile-lightweight = homeModule;
}
