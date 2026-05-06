{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  flake.nixosModules.niri = {
    # imports = [ inputs.niri.nixosModules.niri ];
    # config = {
    #   nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    #   programs.niri = {
    #     enable = false;
    #   };
    # };
  };

  flake.homeModules.niri = {
    imports = [ inputs.niri.homeModules.niri ];
    config = {
      programs.niri = {
        enable = true;
        settings = {
          spawn-at-startup = [
            { sh = "noctalia-shell"; }
          ];
          input = {
            focus-follows-mouse = {
              enable = true;
            };
            touchpad = {
              tap = true;
              natural-scroll = true;
            };
            mouse = {
              scroll-factor = 1;
              scroll-method = "no-scroll";
            };
            trackpoint = {
              accel-speed = 2.0;
            };
          };
          overview = {
            zoom = 0.5;
          };
          layout = {
            gaps = 8;
            center-focused-column = "never";
            preset-column-widths = [
              {
                proportion = 0.33333;
              }
              { proportion = 0.5; }
              { proportion = 0.66667; }
              { proportion = 1.0; }
            ];
            default-column-width.proportion = 1.0;
          };
        };
      };
    };
  };
}
