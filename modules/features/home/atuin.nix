{
  flake.homeModules.atuin = {
    config = {
      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://atuin.taila32e5.ts.net";
          key_path = "~/.local/share/atuin/key";
          search_mode = "prefix";
          style = "compact";
          history_filter = [
            "^clear"
            "^exit"
            "^atuin"
          ];
        };
        flags = [
          "--disable-up-arrow"
        ];
      };
    };
  };
}
