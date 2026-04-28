{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      config = {
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
          ];
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };
    };
}
