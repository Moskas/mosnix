{
  flake.homeModules.shinbun = { pkgs, ... }: {
    # TODO Create module for config and feeds
    config = {
      home.packages = with pkgs; [ shinbun ];
    };
  };
}
