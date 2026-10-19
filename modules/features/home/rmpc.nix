{
  # rmpc set up to look and behave like the ncmpcpp config in mpd.nix:
  # classic ncmpcpp layout (tabs on top, progress bar + status line at the
  # bottom), the default ncmpcpp column colours, the cursor following the
  # playing song, and ncmpcpp's key bindings where they don't clash.
  flake.homeModules.rmpc =
    { pkgs, config, ... }:
    let
      c = config.lib.stylix.colors.withHashtag;

      # A tab holding a single bordered pane.
      tab = name: pane: ''
        (
            name: "${name}",
            pane: Split(
                direction: Vertical,
                panes: [(size: "100%", borders: "ALL", pane: ${pane})],
            ),
        ),
      '';
    in
    {
      # The Visualizer tab runs cava under the hood.
      home.packages = [ pkgs.cava ];

      programs.rmpc = {
        enable = true;
        config = ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
              address: "127.0.0.1:6600",
              theme: "stylix",
              volume_step: 5,
              // autocenter_mode + centered_cursor: follow the playing song and
              // keep the cursor in the middle of the list.
              select_current_song_on_change: true,
              center_current_song_on_change: true,
              scrolloff: 1000,
              wrap_navigation: false,
              enable_mouse: true,
              enable_config_hot_reload: true,
              // execute_on_song_change
              on_song_change: ["song-change"],
              album_art: (
                  method: Auto,
                  max_size_px: (width: 1200, height: 1200),
                  disabled_protocols: ["http://", "https://"],
                  vertical_align: Center,
                  horizontal_align: Center,
              ),
              // Same fifo output ncmpcpp's visualizer reads from.
              cava: (
                  framerate: 60,
                  autosens: true,
                  input: (
                      method: Fifo,
                      source: "/tmp/mpd.fifo",
                      sample_rate: 44100,
                      sample_bits: 16,
                      channels: 2,
                  ),
                  smoothing: (noise_reduction: 77),
              ),
              // Merged into the defaults; a key bound here is removed from
              // every other section.
              keybinds: (
                  global: {
                      "r":  ToggleRepeat,
                      "z":  ToggleRandom,
                      "y":  ToggleSingle,
                      "R":  ToggleConsume,
                      "+":  VolumeUp,
                      "-":  VolumeDown,
                      "u":  Update,
                      "oR": AddRandom,
                      // ncmpcpp screen numbering
                      "1":  SwitchToTab("Queue"),
                      "2":  SwitchToTab("Directories"),
                      "3":  SwitchToTab("Search"),
                      "4":  SwitchToTab("Artists"),
                      "5":  SwitchToTab("Playlists"),
                      "6":  SwitchToTab("Albums"),
                      "7":  ShowOutputs,
                      "8":  SwitchToTab("Visualizer"),
                      "9":  SwitchToTab("Album Artists"),
                  },
                  navigation: {
                      // select_item + scroll_down; rmpc's Select already
                      // advances the cursor. There is no select-and-go-up
                      // action, so K just scrolls up.
                      "J":      Select,
                      "K":      Up,
                      "<C-j>":  MoveDown,
                      "<C-k>":  MoveUp,
                  },
                  queue: {
                      // clear_playlist (asks for confirmation)
                      "c":        DeleteAll,
                      "<Delete>": Delete,
                  },
              ),
              search: (
                  case_sensitive: false,
                  ignore_diacritics: true,
                  search_button: false,
                  mode: Contains,
                  tags: [
                      (value: "any",         label: "Any Tag"),
                      (value: "artist",      label: "Artist"),
                      (value: "album",       label: "Album"),
                      (value: "albumartist", label: "Album Artist"),
                      (value: "title",       label: "Title"),
                      (value: "filename",    label: "Filename"),
                      (value: "genre",       label: "Genre"),
                  ],
              ),
              artists: (
                  album_display_mode: SplitByDate,
                  album_sort_by: Date,
                  album_date_tags: [Date],
              ),
              tabs: [
                  (
                      name: "Queue",
                      pane: Split(
                          direction: Horizontal,
                          panes: [
                              (
                                  size: "30%",
                                  borders: "ALL",
                                  border_symbols: Inherited(parent: Plain, top_right: "┬", bottom_right: "┴"),
                                  pane: Pane(AlbumArt),
                              ),
                              (
                                  size: "70%",
                                  borders: "TOP | RIGHT | BOTTOM",
                                  pane: Split(
                                      direction: Vertical,
                                      panes: [
                                          (size: "1", pane: Pane(QueueHeader())),
                                          (size: "100%", pane: Pane(Queue)),
                                      ],
                                  ),
                              ),
                          ],
                      ),
                  ),
                  ${tab "Directories" "Pane(Directories)"}
                  ${tab "Search" "Pane(Search)"}
                  ${tab "Artists" "Pane(Artists)"}
                  ${tab "Playlists" "Pane(Playlists)"}
                  ${tab "Albums" "Pane(Albums)"}
                  ${tab "Visualizer" "Pane(Cava)"}
                  ${tab "Album Artists" "Pane(AlbumArtists)"}
              ],
          )
        '';
      };

      xdg.configFile."rmpc/themes/stylix.ron".text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
            default_album_art_path: None,
            format_tag_separator: " | ",
            // No parent column, like ncmpcpp's browser; listing and preview split evenly.
            browser_column_widths: [0, 50, 50],
            background_color: None,
            text_color: "${c.base05}",
            header_background_color: None,
            modal_background_color: "${c.base00}",
            modal_backdrop: false,
            preview_label_style: (fg: "${c.base0A}"),
            preview_metadata_group_style: (fg: "${c.base0A}", modifiers: "Bold"),
            // now_playing_prefix "$b$5": bold blue
            highlighted_item_style: (fg: "${c.base0D}", modifiers: "Bold"),
            // ncmpcpp's current_item_prefix: reversed yellow
            current_item_style: (fg: "${c.base00}", bg: "${c.base0A}", modifiers: "Bold"),
            borders_style: (fg: "${c.base03}"),
            highlight_border_style: (fg: "${c.base0D}"),
            symbols: (
                song: "󰎈",
                dir: "",
                playlist: "󰲸",
                marker: "+",
                ellipsis: "…",
                song_style: (fg: "${c.base0B}"),
                dir_style: (fg: "${c.base0D}"),
                playlist_style: (fg: "${c.base0E}"),
            ),
            level_styles: (
                info: (fg: "${c.base0D}", bg: "${c.base00}"),
                warn: (fg: "${c.base0A}", bg: "${c.base00}"),
                error: (fg: "${c.base08}", bg: "${c.base00}"),
                debug: (fg: "${c.base0B}", bg: "${c.base00}"),
                trace: (fg: "${c.base0E}", bg: "${c.base00}"),
            ),
            // progressbar_look "━━ ", progressbar_elapsed_color green:b
            progress_bar: (
                symbols: ["", "━", "━", " ", ""],
                track_style: (fg: "${c.base02}"),
                elapsed_style: (fg: "${c.base0B}", modifiers: "Bold"),
                thumb_style: (fg: "${c.base0B}", modifiers: "Bold"),
                use_track_when_empty: true,
            ),
            scrollbar: (
                symbols: ["│", "█", "▲", "▼"],
                track_style: (fg: "${c.base02}"),
                ends_style: (fg: "${c.base03}"),
                thumb_style: (fg: "${c.base0D}"),
            ),
            tab_bar: (
                active_style: (fg: "${c.base00}", bg: "${c.base0D}", modifiers: "Bold"),
                inactive_style: (fg: "${c.base04}"),
            ),
            lyrics: (timestamp: false),
            cava: (
                // visualizer_look "+"
                bar_symbols: ['+'],
                inverted_bar_symbols: ['+'],
                bar_spacing: 1,
                bar_width: 1,
                orientation: Bottom,
                // ncmpcpp's default visualizer_color, bottom to top
                bar_color: Gradient({
                    0:   "${c.base0D}",
                    20:  "${c.base0C}",
                    40:  "${c.base0B}",
                    60:  "${c.base0A}",
                    80:  "${c.base0E}",
                    100: "${c.base08}",
                }),
            ),
            browser_song_format: [
                (
                    kind: Group([
                        (kind: Property(Track)),
                        (kind: Text(" ")),
                    ])
                ),
                (
                    kind: Group([
                        (kind: Property(Artist)),
                        (kind: Text(" - ")),
                        (kind: Property(Title)),
                    ]),
                    default: (kind: Property(Filename))
                ),
            ],
            // ncmpcpp's default song_columns_list_format:
            // (20)[]{a} (6f)[green]{NE} (50)[white]{t|f:Title} (20)[cyan]{b} (7f)[magenta]{l}
            song_table_format: [
                (
                    prop: (kind: Property(Artist), style: (fg: "${c.base0A}"),
                        default: (kind: Text("<empty>"), style: (fg: "${c.base03}"))),
                    label_prop: (kind: Text("Artist")),
                    width: "22%",
                ),
                (
                    prop: (kind: Property(Track), style: (fg: "${c.base0B}"),
                        default: (kind: Text(""))),
                    label_prop: (kind: Text("#")),
                    width: "4",
                    alignment: Right,
                ),
                (
                    prop: (kind: Property(Title), style: (fg: "${c.base05}"),
                        default: (kind: Property(Filename), style: (fg: "${c.base05}"))),
                    label_prop: (kind: Text("Title")),
                    width: "48%",
                ),
                (
                    prop: (kind: Property(Album), style: (fg: "${c.base0C}"),
                        default: (kind: Text("<empty>"), style: (fg: "${c.base03}"))),
                    label_prop: (kind: Text("Album")),
                    width: "30%",
                ),
                (
                    prop: (kind: Property(Duration), style: (fg: "${c.base0E}"),
                        default: (kind: Text("-"))),
                    label_prop: (kind: Text("Time")),
                    width: "7",
                    alignment: Right,
                ),
            ],
            // ncmpcpp's classic interface: header on top, progress bar and
            // status line at the bottom.
            layout: Split(
                direction: Vertical,
                panes: [
                    (
                        size: "1",
                        pane: Split(
                            direction: Horizontal,
                            panes: [
                                (size: "100%", pane: Pane(Tabs)),
                                (size: "28", pane: Component("header_right")),
                            ],
                        ),
                    ),
                    (size: "100%", pane: Pane(TabContent)),
                    (size: "1", pane: Pane(ProgressBar)),
                    (size: "1", pane: Component("statusline")),
                ],
            ),
            components: {
                // "Volume: 70% [rzyR]" with inactive flags dimmed
                "header_right": Pane(Property(
                    content: [
                        (kind: Text("Volume: "), style: (fg: "${c.base04}")),
                        (kind: Property(Status(Volume)), style: (fg: "${c.base05}", modifiers: "Bold")),
                        (kind: Text("% ["), style: (fg: "${c.base04}")),
                        (kind: Property(Status(RepeatV2(
                            on_label: "r", off_label: "-",
                            on_style: (fg: "${c.base05}", modifiers: "Bold"),
                            off_style: (fg: "${c.base03}"),
                        )))),
                        (kind: Property(Status(RandomV2(
                            on_label: "z", off_label: "-",
                            on_style: (fg: "${c.base05}", modifiers: "Bold"),
                            off_style: (fg: "${c.base03}"),
                        )))),
                        (kind: Property(Status(SingleV2(
                            on_label: "y", off_label: "-", oneshot_label: "1",
                            on_style: (fg: "${c.base05}", modifiers: "Bold"),
                            off_style: (fg: "${c.base03}"),
                            oneshot_style: (fg: "${c.base09}", modifiers: "Bold"),
                        )))),
                        (kind: Property(Status(ConsumeV2(
                            on_label: "R", off_label: "-", oneshot_label: "1",
                            on_style: (fg: "${c.base05}", modifiers: "Bold"),
                            off_style: (fg: "${c.base03}"),
                            oneshot_style: (fg: "${c.base09}", modifiers: "Bold"),
                        )))),
                        (kind: Text("] "), style: (fg: "${c.base04}")),
                    ],
                    align: Right,
                )),
                "statusline": Split(
                    direction: Horizontal,
                    panes: [
                        (size: "100%", pane: Component("now_playing")),
                        (size: "34", pane: Component("time")),
                    ],
                ),
                // "Playing: Artist - Title"
                "now_playing": Pane(Property(
                    content: [
                        (kind: Property(Status(StateV2(
                            playing_label: "Playing: ",
                            paused_label: "Paused: ",
                            stopped_label: "Stopped",
                            playing_style: (fg: "${c.base0D}", modifiers: "Bold"),
                            paused_style: (fg: "${c.base0A}", modifiers: "Bold"),
                            stopped_style: (fg: "${c.base03}", modifiers: "Bold"),
                        )))),
                        (kind: Group([
                            (kind: Property(Song(Artist)), style: (fg: "${c.base0A}")),
                            (kind: Text(" - "), style: (fg: "${c.base04}")),
                        ])),
                        (kind: Property(Song(Title)), style: (fg: "${c.base05}", modifiers: "Bold"),
                            default: (kind: Property(Song(Filename)))),
                    ],
                    align: Left,
                    scroll_speed: 1,
                )),
                // "[0:42/3:58] 42 songs, 2h13m" (playlist_shorten_total_times)
                "time": Pane(Property(
                    content: [
                        (kind: Property(Status(InputBuffer())), style: (fg: "${c.base0D}")),
                        (kind: Text(" [")),
                        (kind: Property(Status(Elapsed)), style: (modifiers: "Bold")),
                        (kind: Text("/")),
                        (kind: Property(Status(Duration)), style: (modifiers: "Bold")),
                        (kind: Text("] ")),
                        (kind: Property(Status(QueueLength())), style: (fg: "${c.base04}")),
                        (kind: Text(" songs, "), style: (fg: "${c.base04}")),
                        (kind: Property(Status(QueueTimeTotal(separator: ""))), style: (fg: "${c.base04}")),
                        (kind: Text(" ")),
                    ],
                    align: Right,
                )),
            },
        )
      '';
    };
}
