{ inputs, ... }:
{
  flake.nixosModules.niri = {
    config = {
      nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      programs.niri.enable = true;
    };
  };

  flake.homeModules.niri = {
    config = {
      programs.niri = {
        enable = true;
      };
    };
  };
}
