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
      starship
      wallpapers
      zoxide
      zsh
    ];
    programs.niri.settings.spawn-at-startup = [
      { sh = "noctalia-shell"; }
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
