{
  flake.homeModules.ranger =
    { pkgs, lib, ... }:
    {
      config = {
        programs.ranger = {
          enable = true;
          aliases = {
            e = "edit";
          };
          mappings = {
            W = "set_wallpaper";
          };
          settings = {
            preview_images = true;
            preview_images_method = "kitty";
            preview_script = "~/.config/ranger/scope.sh";
            vcs_aware = true;
            draw_borders = "both";
            mouse_enabled = true;
            update_title = true;
            padding_right = false;
          };
          rifle = [
            {
              condition = "mime ^image";
              command = ''${lib.getExe pkgs.swayimg} -- "$@"'';
            }
            {
              condition = "mime ^text";
              command = ''emacs -nw -- "$@"'';
            }
            {
              condition = "ext pdf|djvu|epub";
              command = ''zathura -- "$@"'';
            }
            {
              condition = "mime ^video";
              command = ''mpv -- "$@"'';
            }
          ];
          extraConfig = "default_linemode devicons";
          plugins = [
            {
              name = "ranger_devicons";
              src = pkgs.fetchFromGitHub {
                owner = "alexanderjeurissen";
                repo = "ranger_devicons";
                rev = "1bcaff0366a9d345313dc5af14002cfdcddabb82";
                hash = "sha256-qvWqKVS4C5OO6bgETBlVDwcv4eamGlCUltjsBU3gAbA=";
              };
            }
            {
              name = "zoxide";
              src = pkgs.fetchFromGitHub {
                owner = "jchook";
                repo = "ranger-zoxide";
                rev = "c64d4aed906487cc8c648f51814682a2c01c21d9";
                hash = "sha256-63EAmdvOxfaBVHKxAp4OyAA+nX3+FPlqFXTvKrmAnYE=";
              };
            }
            {
              name = "ranger-archives";
              src = pkgs.fetchFromGitHub {
                owner = "maximtrp";
                repo = "ranger-archives";
                rev = "0b1cfa9a77412c3b51da5b1b213c672227f9fbb4";
                hash = "sha256-HEJ+8KlG++PK0vVpEYptbyuPZAKllX5PeyaTBKcf+8M=";
              };
            }
          ];
        };
      };
    };
}
