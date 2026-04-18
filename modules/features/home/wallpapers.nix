{
  flake.homeModules.wallpapers =
    { pkgs, ... }:
    {
      config = {
        home.file."./Pictures/Wallpapers".source = pkgs.fetchFromGitHub {
          owner = "Moskas";
          repo = "wallpapers";
          rev = "bf9d104e6b4dfd3de489a888009119a65a35087d";
          hash = "sha256-gIgORCdxtpvkCOghaMAFZsC6w1gdd2nw5s/1lxOZyJk=";
        };
      };
    };
}
