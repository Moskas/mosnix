{
  flake.homeModules.mpd =
    { pkgs, config, ... }:
    let
      notify = pkgs.writeShellScriptBin "song-change" ''
        TITLE=$(${pkgs.mpc}/bin/mpc --format "%title%" current)
        ARTIST=$(${pkgs.mpc}/bin/mpc --format "%artist%" current)
        ALBUM=$(${pkgs.mpc}/bin/mpc --format "%album%" current)
        FILE=$(${pkgs.mpc}/bin/mpc --format "%file%" current)

        # Find directory of the song (relative to your music dir)
        MUSIC_DIR="$HOME/Music"
        SONG_DIR=$(dirname "$MUSIC_DIR/$FILE")

        # Try to find cover image (common filenames: cover.jpg/png, folder.jpg/png)
        COVER=""
        for name in cover.jpg cover.png folder.jpg folder.png; do
            if [ -f "$SONG_DIR/$name" ]; then
                COVER="$SONG_DIR/$name"
                break
            fi
        done

        ${pkgs.libnotify}/bin/notify-send -i "$COVER" \
            "Now playing" \
            " $ARTIST\n󰎇 $TITLE\n󰗮 $ALBUM"
      '';
    in
    {
      config = {
        home.packages = with pkgs; [
          mpc
          mpdas
        ];

        services.mpd = {
          enable = true;
          musicDirectory = "${config.home.homeDirectory}/Music";

          network = {
            listenAddress = "localhost";
            port = 6600;
          };

          dataDir = "${config.xdg.dataHome}/mpd";
          playlistDirectory = "${config.xdg.dataHome}/mpd/playlists";

          extraConfig = ''
            auto_update "yes"
            restore_paused "yes"
            metadata_to_use "artist,album,title,track,name,genre,date,composer,performer"

            audio_output {
              type  "pipewire"
              name  "pipewire"
            }

            audio_output {
              type    "fifo"
              name    "visualizer"
              path    "/tmp/mpd.fifo"
              format  "44100:16:2"
            }
          '';
        };

        services.mpd-mpris.enable = true;

        programs.ncmpcpp = {
          enable = true;
          package = pkgs.ncmpcpp.override {
            visualizerSupport = true;
            taglibSupport = true;
            outputsSupport = true;
          };
          mpdMusicDir = "${config.home.homeDirectory}/Music";
          settings = {
            visualizer_data_source = "/tmp/mpd.fifo";
            visualizer_output_name = "visualizer";
            visualizer_in_stereo = "yes";
            visualizer_look = "+";
            progressbar_look = "━━ ";
            autocenter_mode = "yes";
            centered_cursor = "yes";
            now_playing_prefix = "$b$5";
            now_playing_suffix = "$/b$9";
            playlist_shorten_total_times = "yes";
            volume_change_step = 5;
            execute_on_song_change = "${notify}/bin/song-change";
          };

          bindings = [
            {
              key = "j";
              command = "scroll_down";
            }
            {
              key = "k";
              command = "scroll_up";
            }
            {
              key = "J";
              command = [
                "select_item"
                "scroll_down"
              ];
            }
            {
              key = "K";
              command = [
                "select_item"
                "scroll_up"
              ];
            }
          ];
        };

        services.mpd-discord-rpc = {
          enable = true;
          settings = {
            hosts = [ "localhost:6600" ];
            format = {
              details = "$title";
              state = "On $album by $artist";
            };
          };
        };

        services.mpdscribble = {
          enable = true;
        };

        programs.rmpc.enable = true;

        home.sessionVariables.MPD_HOST = "localhost";

      };
    };
}
