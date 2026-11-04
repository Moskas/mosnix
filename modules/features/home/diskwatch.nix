{
  flake.homeModules.diskwatch =
    { pkgs, ... }:
    let
      configFile = (pkgs.formats.toml { }).generate "diskwatch-config.toml" {
        theme = "terminal";
        graph = "bars";
        graph_fade = false;
        view = "full";
        tab = "overview";
        smart_interval_secs = 300;
        refresh_interval_ms = 1000;
        temp_unit = "celsius";
        columns = [
          "size"
          "free"
          "used_pct"
          "temp"
          "smart"
        ];
      };
      # smartctl needs root, so SMART data shows under `sudo diskwatch`; sudo resets
      # HOME and env, hence the config path is baked into the wrapper
      diskwatch = pkgs.symlinkJoin {
        name = "diskwatch";
        paths = [ pkgs.diskwatch ];
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
        postBuild = ''
          wrapProgram $out/bin/diskwatch \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.smartmontools ]} \
            --set-default DISKWATCH_CONFIG ${configFile}
        '';
      };
    in
    {
      config = {
        home.packages = [ diskwatch ];
      };
    };
}
