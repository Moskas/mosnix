{
  flake.homeModules.mpv =
    { pkgs, ... }:
    {
      config = {
        programs.mpv = {
          enable = true;
          config = {
            vo = "gpu-next";
            hwdec = "auto-safe";
            force-window = true;
            # thumbnail script ships its own osc
            osc = false;
          };
          bindings = {
            F = "script-binding quality_menu/video_formats_toggle #! Stream Quality > Video";
            "Alt+f" = "script-binding quality_menu/audio_formats_toggle #! Stream Quality > Audio";
          };
          scripts = with pkgs.mpvScripts; [
            autosub
            sponsorblock
            quality-menu
            mpris
            thumbnail
            twitch-chat
          ];
        };
      };
    };
}
