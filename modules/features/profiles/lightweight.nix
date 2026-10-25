{ self, ... }:
{
  # `terminal` plus a sway desktop for old hardware without GL 3 (no niri/noctalia/kitty).
  flake.homeModules.lightweight = {
    key = "moskas/lightweight";

    imports = with self.homeModules; [
      terminal
      sway
      foot
      fuzzel
      waybar
      mpd
      mpv
      rmpc
      swayimg
      wallpapers
      zathura
    ];
  };

  flake.nixosModules.lightweight = {
    imports = with self.nixosModules; [
      terminal
      sway
      ly
    ];

    home-manager.users.moskas.imports = [ self.homeModules.lightweight ];
  };
}
