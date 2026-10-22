{
  # Image renderer called by n8n workflows. The app itself (server.py, fonts,
  # audio) lives unmanaged in /var/lib/slide-renderer.
  flake.nixosModules.slideRenderer =
    { config, pkgs, ... }:
    {
      config = {
        # IMGBB_API_KEY=...
        sops.secrets.slide_renderer_env = {
          mode = "0400";
        };
        fonts.packages = with pkgs; [ inter ];
        systemd.services.slide-renderer = {
          description = "Slide Image Renderer";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.ffmpeg-full ];
          environment = {
            INTER_MEDIUM = "/var/lib/slide-renderer/Inter-Medium.otf";
            INTER_LIGHT = "/var/lib/slide-renderer/inter-light.otf";
            AMBIENT_TRACK = "/var/lib/slide-renderer/bgm.mp3";
          };
          serviceConfig = {
            WorkingDirectory = "/var/lib/slide-renderer";
            EnvironmentFile = config.sops.secrets.slide_renderer_env.path;
            ExecStart = "${
              pkgs.python3.withPackages (
                ps: with ps; [
                  flask
                  pillow
                  requests
                ]
              )
            }/bin/python3 /var/lib/slide-renderer/server.py";
            Restart = "always";
            User = "nobody";
          };
        };
      };
    };
}
