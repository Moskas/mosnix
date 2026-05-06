{
  flake.nixosModules.commonWorkstation = {
    config = {
      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
    };
  };
}
