{
  flake.nixosModules.laptop =
    { pkgs, ... }:
    {
      config = {
        services = {
          thermald.enable = true;
          upower.enable = true;
          tlp = {
            enable = true;
            settings = {
              CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
              CPU_SCALING_GOVERNOR_ON_AC = "performance";
              WIFI_PWR_ON_BAT = "N";
            };
          };
        };

        environment.systemPackages = with pkgs; [
          brightnessctl
          upower
        ];
      };
    };
}
