{ self, ... }:
let
  homeModule = {
    imports = with self.homeModules; [
      atuin
      bat
      btop
      carapace
      claude
      direnv
      emacs
      eza
      firefox
      fuzzel
      git
      kitty
      mpd
      nixcord
      niri
      noctalia
      opencode
      prism
      ranger
      shinbun
      starship
      terminal-utils
      tickrs
      tmux
      wallpapers
      zoxide
      zsh
    ];
    wayland.windowManager.niri.settings._children = [
      { spawn-at-startup._args = [ "noctalia" ]; }
    ];
  };
in
{
  flake.nixosModules.profile-full = {
    imports = [
      self.nixosModules.niri
      self.nixosModules.ly
    ];
    home-manager.users."moskas".imports = [ homeModule ];
  };

  flake.homeModules.profile-full = homeModule;
}
