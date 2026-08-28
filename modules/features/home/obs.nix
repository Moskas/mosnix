{ self, ... }:
{
  flake.homeModules.obs =
    {
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.moskas.obs;
    in
    {
      imports = [ self.homeModules.moskasOptions ];

      config = {
        programs.obs-studio = {
          enable = true;
          package = pkgs.obs-studio.override {
            cudaSupport = cfg.cuda;
          };
          plugins = with pkgs.obs-studio-plugins; [
            obs-vkcapture
            wlrobs
            obs-vaapi
          ];
        };
      };
    };
}
