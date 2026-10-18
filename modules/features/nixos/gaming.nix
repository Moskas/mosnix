{ self, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      config = {
        # Pull the matching home-manager config in automatically so hosts only
        # need `self.nixosModules.gaming` and don't have to wire the homeModule
        # into their home profile separately.
        home-manager.sharedModules = [ self.homeModules.gaming ];

        programs.steam = {
          enable = true;
          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = true;
              OBS_VKCAPTURE = true;
            };
            extraLibraries =
              p: with p; [
                atk
              ];
          };
          extraCompatPackages = with pkgs; [
            proton-ge-bin
            dwproton
          ];
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };
    };

  flake.homeModules.gaming =
    { pkgs, lib, ... }:
    {
      config = {
        sharedModules = [ self.homeModules.prism ];
        programs = {
          mangohud = {
            enable = true;
            enableSessionWide = true;
            settings = {
              font_scale = lib.mkForce 1.5;
            };
            settingsPerApplication = {
              mpv = {
                no_display = true;
              };
            };
          };
        };
        home.packages = with pkgs; [
          vintagestory
          heroic-unwrapped
          bottles-unwrapped
          moonlight-qt
        ];
      };
    };
}
