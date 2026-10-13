{ self, ... }:
{
  # `terminal` plus the Wayland desktop and GUI applications.
  flake.homeModules.graphical = {
    key = "moskas/graphical";

    imports = with self.homeModules; [
      terminal
      carapace
      claude
      direnv
      emacs
      easyeffects
      firefox
      fuzzel
      kitty
      mpd
      nixcord
      niri
      noctalia
      opencode
      prism
      tickrs
      wallpapers
      zathura
    ];
  };

  flake.nixosModules.graphical = {
    imports = with self.nixosModules; [
      terminal
      niri
      ly
    ];

    home-manager.users.moskas.imports = [ self.homeModules.graphical ];
  };
}
