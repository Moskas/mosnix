{ self, ... }:
{
  # `terminal` plus the Wayland desktop and GUI applications.
  flake.homeModules.graphical = {
    key = "moskas/graphical";

    imports = with self.homeModules; [
      terminal
      carapace
      easyeffects
      qtColors
      firefox
      fuzzel
      kitty
      mpd
      mpv
      nixcord
      niri
      noctalia
      opencode
      prism
      rmpc
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
