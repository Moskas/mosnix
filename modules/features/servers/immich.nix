{
  flake.nixosModules.immich = {
    config = {
      services.immich = {
        enable = true;
        port = 2283;
        host = "127.0.0.1";
        #mediaLocation = "/media/immich"; # Or another preferred path
        #settings = {
        #server.externalDomain = "http://immich.laffey";
        #newVersionCheck.enabled = false;
        #};
        #openFirewall = true;
        #database.enable = true;
        #redis.enable = true;
        accelerationDevices = [
          "/dev/dri/renderD128"
        ];
      };
      users.users.immich.extraGroups = [
        "video"
        "render"
      ];

    };
  };
}
