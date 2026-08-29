{
  flake.nixosModules.nvidia =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      config = {
        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
              nvidia-vaapi-driver
              libva-vdpau-driver
            ];
          };
          nvidia = {
            modesetting.enable = true;
            open = lib.mkDefault true;
            package = config.boot.kernelPackages.nvidiaPackages.production;
          };
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        boot.extraModprobeConfig =
          "options nvidia "
          + lib.concatStringsSep " " [
            "NVreg_UsePageAttributeTable=1"
            "NVreg_EnablePCIeGen3=1"
          ];

        environment.variables = {
          LIBVA_DRIVER_NAME = "nvidia";
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
          NIXOS_OZONE_WL = "1";
          MOZ_DISABLE_RDD_SANDBOX = "1";
          EGL_PLATFORM = "wayland";
        };
      };
    };
}
