{
  flake.homeModules.kitty = {
    config = {
      programs.kitty = {
        enable = true;
        settings = {
          enable_audio_bell = false;
          window_padding_width = 5;
          disable_ligatures = "never";
          confirm_os_window_close = 0;
        };
        keybindings = {
          "ctrl+alt+c" = "copy_ansi_to_clipboard";
        };
      };
    };
  };
}
