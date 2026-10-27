{
  flake.nixosModules.rgb =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.services.hardware.openrgb;
    in
    {
      options.moskas.rgb.color = lib.mkOption {
        type = lib.types.strMatching "[0-9A-Fa-f]{6}";
        default = "FF0000";
        description = "Hex color applied to every OpenRGB device in Direct mode at server startup.";
      };

      config = {
        services.hardware.openrgb = {
          enable = true;
          motherboard = lib.mkDefault "amd";
        };

        # The server applies CLI device options after detection, replacing the GUI-made profile
        systemd.services.openrgb.serviceConfig.ExecStart = lib.mkForce (
          lib.escapeShellArgs [
            (lib.getExe cfg.package)
            "--server"
            "--server-port"
            cfg.server.port
            "--mode"
            "direct"
            "--color"
            config.moskas.rgb.color
          ]
        );

        # Direct mode colors are lost on suspend, restarting the server reapplies them
        powerManagement.resumeCommands = ''
          ${config.systemd.package}/bin/systemctl --no-block restart openrgb.service
        '';

        environment.systemPackages = with pkgs; [
          i2c-tools
        ];
      };
    };
}
