{
  flake.nixosModules.jellyfin = {
    config = {
      services.jellyfin = {
        enable = true;
        # Reached via the tsnsrv `jellyfin` node; set the published server URL to
        # https://jellyfin.taila32e5.ts.net in Dashboard -> Networking.
        openFirewall = false;
      };
    };
  };
}
