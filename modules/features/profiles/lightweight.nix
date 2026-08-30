{ self, ... }:
let
  homeModule = {
    imports = with self.homeModules; [
      niri
      waybar
      mako
      kitty
      fuzzel
      shinbun
      terminal-utils
      tmux
      wallpapers
      zathura
    ];
    wayland.windowManager.niri.settings._children = [
      { spawn-at-startup._args = [ "waybar" ]; }
      { spawn-at-startup._args = [ "mako" ]; }
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
