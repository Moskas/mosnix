{
  flake.nixosModules.common = {
    config = {
      environment.pathsToLink = [
        "/share/applications"
        "/share/xdg-desktop-portal"
      ];
    };
  };
}
