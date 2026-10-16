{
  flake.homeModules.git =
    { pkgs, ... }:
    {
      config = {
        programs = {
          git = {
            enable = true;
            settings = {
              user = {
                name = "Moskas";
                email = "minemoskas@gmail.com";
              };
              init.defaultBranch = "master";
              rebase = {
                autoSquash = true;
                autoStash = true;
              };
              rerere = {
                autoupdate = true;
                enabled = true;
              };
              alias = {
                cl = "clone";
                ct = "commit";
                co = "checkout";
                ss = "status -bs";
                st = "stash";
                ad = "add";
                df = "diff";
                ps = "push";
                pl = "pull";
              };
            };
            ignores = [
              ".direnv/"
              "result"
              "*.qcow2"
              ".claude"
              "CLAUDE.md"
            ];
          };

          gh = {
            enable = true;
            gitCredentialHelper.enable = true;
            extensions = [ pkgs.gh-signoff ];
            settings = {
              git_protocol = "ssh";
              prompt = "enabled";
              aliases = {
                co = "pr checkout";
                pv = "pr view";
              };
            };
          };

          lazygit = {
            enable = true;
            settings = {
              gui.theme.authorColors."*" = "cyan";
            };
          };
        };
      };
    };
}
