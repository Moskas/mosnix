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
          };

          jack.enable = true;
        };

        security.rtkit.enable = true;

        environment.systemPackages = with pkgs; [ pulsemixer ];
      };
    };
}
