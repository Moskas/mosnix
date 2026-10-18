{
  flake.homeModules.brave =
    { pkgs, ... }:

    {
      config = {
        programs.brave = {
          enable = true;
          extensions = [
            {
              id = "dcpihecpambacapedldabdbpakmachpb";
              updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
            }
            {
              id = "nngceckbapebfimnlniiiahkandclblb"; # bitwarden
            }
            {
              id = "ajopnjidmegmdimjlfnijceegpefgped"; # BTTV
            }
            {
              id = "fadndhdgpmmaapbmfcknlfgcflmmmieb"; # FFZ
            }
          ];
        };

        home.packages = with pkgs; [
          (makeDesktopItem {
            name = "brave-private";
            desktopName = "Brave Web Browser - incognito";
            genericName = "Open a private Brave window";
            icon = "brave-browser";
            exec = "${brave}/bin/brave --incognito";
            categories = [ "Network" ];
          })
        ];
      };
    };
}
