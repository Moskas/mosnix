{
  flake.nixosModules.commonWorkstation =
    { pkgs, ... }:
    {
      config = {
        services.pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;
          wireplumber = {
            enable = true;
            # keep sinks open so idle HDMI audio controllers don't runtime-suspend
            # and miss the monitor's hotplug/ELD events
            extraConfig."99-disable-suspend" = {
              "monitor.alsa.rules" = [
                {
                  matches = [ { "node.name" = "~alsa_output.*"; } ];
                  actions.update-props."session.suspend-timeout-seconds" = 0;
                }
              ];
            };
          };

          jack.enable = true;
        };

        security.rtkit.enable = true;

        environment.systemPackages = with pkgs; [ pulsemixer ];
      };
    };
}
