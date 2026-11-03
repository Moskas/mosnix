{
  flake.homeModules.tmux =
    { lib, pkgs, ... }:
    let
      resurrectDir = "$HOME/.local/share/tmux/resurrect";

      # Saved commands keep absolute nix paths, which break after a rebuild or gc.
      # Strip them so restore resolves through PATH instead.
      resurrectStripPaths = pkgs.writeShellScript "resurrect-strip-paths" ''
        target=$(${lib.getExe' pkgs.coreutils "readlink"} -f "$1")
        ${lib.getExe pkgs.gnused} -i -E \
          -e 's#/nix/store/[^/]+/bin/##g' \
          -e 's#/etc/profiles/per-user/[^/]+/bin/##g' \
          -e 's#/run/current-system/sw/bin/##g' \
          -e "s#$HOME/.nix-profile/bin/##g" \
          "$target"
      '';
    in
    {
      config = {
        home.packages = [
          (pkgs.writeShellScriptBin "bat-stat" ''
            for battery in /sys/class/power_supply/BAT*; do
              [ -d "$battery" ] || continue

              capacity=$(cat "$battery/capacity")
              status=$(cat "$battery/status")

              case "$status" in
                "Charging")
                  symbol="󱟠"
                  ;;
                "Discharging")
                  symbol="󱟞"
                  ;;
                "Full")
                  symbol="󰁹"
                  ;;
                "Unknown")
                  symbol="󰂑"
                  ;;
                "Not charging")
                  symbol="󱟢"
                  ;;
                *)
                  symbol="󰂑"
                  ;;
              esac

              printf "%s %s%%  " "$symbol" "$capacity"
            done
          '')
        ];
        programs.tmux = {
          enable = true;
          mouse = true;
          secureSocket = true;
          clock24 = true;
          keyMode = "emacs";
          baseIndex = 1;
          shortcut = "Space";
          terminal = "tmux-256color";
          historyLimit = 50000;
          escapeTime = 0;
          focusEvents = true;
          aggressiveResize = true;
          shell = "${pkgs.zsh}/bin/zsh";
          # After stylix's base16 `source-file` so these styles override the theme.
          extraConfig = lib.mkAfter ''
            set -as terminal-features ',xterm-kitty:RGB:extkeys,foot*:RGB:extkeys,*256col*:RGB'
            set -s extended-keys on
            set -s set-clipboard on
            set -g allow-passthrough on

            set -g renumber-windows on
            set -g detach-on-destroy off
            set -g display-time 2000
            set -g set-titles off
            # Window names: directory while at the shell, otherwise the running command
            set -g allow-rename off
            set -g automatic-rename on
            set -g automatic-rename-format '#{?#{==:#{pane_current_command},zsh},#{b:pane_current_path},#{pane_current_command}}'

            set -g pane-border-style fg=brightblack
            set -g pane-active-border-style fg=green
            set -g message-style bg=default,fg=yellow
            set -g message-command-style bg=default,fg=yellow
            # Replace the remaining hex colours from stylix's base16 theme with ANSI ones
            set -g mode-style fg=black,bg=yellow
            set -g display-panes-colour brightblack
            set -g display-panes-active-colour green
            set -g clock-mode-colour blue

            set -g status-interval 5
            set -g status-justify left
            set -g status-style bg=default,fg=white
            set -g status-left-length 40
            set -g status-right-length 100

            # Session pill: green, yellow while prefix is armed, blue in copy mode
            set -g status-left '#[fg=black,bold,bg=#{?client_prefix,yellow,#{?pane_in_mode,blue,green}}] #S #[default] '

            set -g window-status-style fg=brightblack,bg=default
            set -g window-status-current-style fg=green,bg=default,bold
            set -g window-status-activity-style fg=yellow,bg=default
            set -g window-status-bell-style fg=red,bg=default,bold
            set -g window-status-separator ""
            set -g window-status-format ' #I #W#{?window_zoomed_flag, 󰁌,}#{?window_bell_flag, 󰂞,} '
            set -g window-status-current-format ' #I #W#{?window_zoomed_flag, 󰁌,} '

            set -g status-right '#{?pane_synchronized,#[fg=red]SYNC  #[default],}#[fg=blue]󰒋 #h  #[fg=cyan]#(bat-stat)#[fg=magenta]%a %d %b  #[fg=white,bold]%H:%M '

            bind c new-window -c '#{pane_current_path}'
            bind V split-window -h -c '#{pane_current_path}'
            bind S split-window -v -c '#{pane_current_path}'
            bind - select-layout even-vertical
            bind | select-layout even-horizontal
            bind y set synchronize-panes
            bind N new-session
            bind r source-file ~/.config/tmux/tmux.conf\; display 'Config reloaded'
            unbind '%'
            unbind '"'
            bind -n C-S-j previous-window
            bind -n C-S-k next-window

            # Continuum hooks its autosave into status-right, so it must load after it's set
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '10'
            run-shell ${pkgs.tmuxPlugins.continuum.rtp}
          '';
          plugins = with pkgs; [
            {
              plugin = tmuxPlugins.resurrect;
              extraConfig = ''
                set -g @resurrect-dir '${resurrectDir}'
                set -g @resurrect-capture-pane-contents 'on'
                set -g @resurrect-processes '"~emacsclient" btop lf ranger rmpc'
                set -g @resurrect-hook-post-save-layout '${resurrectStripPaths}'
              '';
            }
            {
              plugin = tmuxPlugins.better-mouse-mode;
              # Fullscreen TUIs without mouse reporting get arrow keys, like the terminal does
              extraConfig = ''
                set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
              '';
            }
            tmuxPlugins.tilish
            tmuxPlugins.tmux-fzf
            tmuxPlugins.yank
            tmuxPlugins.extrakto
          ];
        };
      };
    };
}
