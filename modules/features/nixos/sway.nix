{
  flake.nixosModules.sway = {
    config = {
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        # foot, swayidle, swaylock etc. come from home-manager
        extraPackages = [ ];
      };
      security.polkit.enable = true;
      xdg.portal.wlr.enable = true;
    };
  };

  flake.homeModules.sway =
    { pkgs, lib, ... }:
    let
      mod = "Mod4";
      # Show the scratchpad window, or spawn it and show it on first use
      scratchpad =
        appId: cmd:
        "exec swaymsg '[app_id=\"^${appId}$\"] scratchpad show' "
        + "|| (${cmd} & sleep 0.5 && swaymsg '[app_id=\"^${appId}$\"] scratchpad show')";
      workspaces = map toString (lib.range 1 9);
      # Random dark wallpaper from the `wallpapers` module, like noctalia's directory_dark
      wallpaper = pkgs.writeShellScript "sway-wallpaper" ''
        img=$(${pkgs.findutils}/bin/find -L "$HOME/Pictures/Wallpapers" -path '*/dark/*' \
          \( -name '*.png' -o -name '*.jpg' \) | ${pkgs.coreutils}/bin/shuf -n 1)
        [ -n "$img" ] || exit 0
        ${pkgs.procps}/bin/pkill -x swaybg
        exec ${lib.getExe pkgs.swaybg} -m fill -i "$img"
      '';
    in
    {
      config = {
        home.packages = with pkgs; [
          wl-clipboard
          grim
          slurp
          playerctl
        ];

        wayland.windowManager.sway = {
          enable = true;
          # The NixOS module provides the wrapped sway and its session file
          package = null;
          config = {
            modifier = mod;
            terminal = "foot";
            menu = "fuzzel";
            bars = [ ];
            gaps.inner = 4;
            window.titlebar = false;
            floating.titlebar = false;
            startup = [ { command = "${wallpaper}"; } ];

            input = {
              "type:touchpad" = {
                tap = "enabled";
                natural_scroll = "enabled";
              };
              "type:pointer" = {
                accel_profile = "flat";
                pointer_accel = "0.2";
                middle_emulation = "enabled";
              };
            };

            window.commands = [
              {
                criteria.app_id = "^scratch-";
                command = "floating enable, resize set 60 ppt 60 ppt, move scratchpad";
              }
            ];

            keybindings = {
              "${mod}+Return" = "exec foot";
              "${mod}+t" = "exec foot";
              "${mod}+d" = "exec fuzzel";
              "${mod}+q" = "kill";
              "Mod4+Mod1+l" = "exec swaylock -f";

              "${mod}+grave" = scratchpad "scratch-term" "foot --app-id scratch-term";
              "${mod}+Shift+m" = scratchpad "scratch-music" "foot --app-id scratch-music rmpc";
              "${mod}+Mod1+r" = scratchpad "scratch-ranger" "foot --app-id scratch-ranger ranger";

              "${mod}+h" = "focus left";
              "${mod}+j" = "focus down";
              "${mod}+k" = "focus up";
              "${mod}+l" = "focus right";
              "${mod}+Left" = "focus left";
              "${mod}+Down" = "focus down";
              "${mod}+Up" = "focus up";
              "${mod}+Right" = "focus right";
              "${mod}+Ctrl+h" = "move left";
              "${mod}+Ctrl+j" = "move down";
              "${mod}+Ctrl+k" = "move up";
              "${mod}+Ctrl+l" = "move right";
              "${mod}+Ctrl+Left" = "move left";
              "${mod}+Ctrl+Down" = "move down";
              "${mod}+Ctrl+Up" = "move up";
              "${mod}+Ctrl+Right" = "move right";

              "${mod}+b" = "splith";
              "${mod}+n" = "splitv";
              "${mod}+w" = "layout tabbed";
              "${mod}+e" = "layout toggle split";
              "${mod}+f" = "fullscreen toggle";
              "${mod}+v" = "floating toggle";
              "${mod}+Shift+v" = "focus mode_toggle";
              "${mod}+r" = "mode resize";

              "${mod}+Shift+w" = "exec ${wallpaper}";
              "${mod}+Shift+c" = "reload";
              "${mod}+Shift+e" = "exec swaymsg exit";

              "Print" = "exec grim - | wl-copy";
              "Ctrl+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";

              "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
              "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              "XF86AudioPlay" = "exec playerctl play-pause";
              "XF86AudioStop" = "exec playerctl stop";
              "XF86AudioPrev" = "exec playerctl previous";
              "XF86AudioNext" = "exec playerctl next";
              "XF86MonBrightnessUp" = "exec brightnessctl --class=backlight set +10%";
              "XF86MonBrightnessDown" = "exec brightnessctl --class=backlight set 10%-";
            }
            // lib.listToAttrs (
              lib.concatMap (ws: [
                (lib.nameValuePair "${mod}+${ws}" "workspace number ${ws}")
                (lib.nameValuePair "${mod}+Ctrl+${ws}" "move container to workspace number ${ws}")
              ]) workspaces
            );
          };
        };

        services.mako = {
          enable = true;
          settings.default-timeout = 5000;
        };

        programs.swaylock.enable = true;

        services.swayidle = {
          enable = true;
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.swaylock}/bin/swaylock -f";
            }
            {
              timeout = 600;
              command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
              resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
            }
          ];
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.swaylock}/bin/swaylock -f";
            }
          ];
        };
      };
    };
}
