{ self, ... }:
{
  flake.nixosModules.gaming =
    {
      config,
      pkgs,
      ...
    }:
    let
      gamescopeCfg = config.programs.gamescope;
      # The capSysNice wrapper can't run inside Steam's bwrap sandbox, so launch
      # options like `gamescope -- %command%` use this copy, carrying the same args.
      steamGamescope =
        if gamescopeCfg.args == [ ] then
          gamescopeCfg.package
        else
          pkgs.symlinkJoin {
            name = "gamescope";
            paths = [ gamescopeCfg.package ];
            nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
            postBuild = ''
              wrapProgram $out/bin/gamescope --add-flags "${toString gamescopeCfg.args}"
            '';
          };
    in
    {
      config = {
        # SteamOS value; some Proton titles exhaust the NixOS default
        boot.kernel.sysctl."vm.max_map_count" = 2147483642;

        # Pull the matching home-manager config in automatically so hosts only
        # need `self.nixosModules.gaming` and don't have to wire the homeModule
        # into their home profile separately.
        home-manager.sharedModules = [
          self.homeModules.gaming
          self.homeModules.prism
          self.homeModules.etterna
        ];

        # gamemoded's polkit rule only lets the gamemode group switch governors
        users.users.moskas.extraGroups = [ "gamemode" ];

        programs = {
          gamemode = {
            enable = true;
            settings = {
              general.renice = 10;
              custom = {
                start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
                end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
              };
            };
          };

          gamescope = {
            enable = true;
            capSysNice = true;
          };

          steam = {
            enable = true;
            extraPackages = [ steamGamescope ];
            # Translate X11 input to uinput so Steam Input works under Wayland
            extest.enable = true;
            protontricks.enable = true;
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
    };

  flake.homeModules.gaming =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      config = {
        programs = {
          mangohud = {
            enable = true;
            enableSessionWide = true;
            settings = {
              font_scale = lib.mkForce 1.5;
              gpu_stats = true;
              gpu_temp = true;
              cpu_stats = true;
              cpu_temp = true;
              vram = true;
              ram = true;
              fps = true;
              frametime = true;
              frame_timing = true;
            }
            # stylix leaves ram unset and reuses hues for vram/engine
            // (with config.lib.stylix.colors; {
              vram_color = lib.mkForce base0E;
              ram_color = base08;
              engine_color = lib.mkForce base09;
              wine_color = lib.mkForce base09;
            });
            settingsPerApplication = {
              mpv = {
                no_display = true;
              };
            };
          };
        };
        home.packages = with pkgs; [
          vintagestory
          heroic
          bottles-unwrapped
          osu-lazer-bin
        ];
      };
    };
}
