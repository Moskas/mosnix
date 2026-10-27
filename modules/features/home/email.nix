{ self, inputs, ... }:
{
  flake.homeModules.email =
    { pkgs, config, ... }:
    {
      imports = [ self.homeModules.sops ];

      config = {
        # Google app password; read by himalaya on each connection
        sops.secrets.email_password = { };

        accounts.email.accounts.gmail = {
          primary = true;
          flavor = "gmail.com";
          address = "minemoskas@gmail.com";
          userName = "minemoskas@gmail.com";
          realName = "Moskas";
          passwordCommand = [
            "cat"
            config.sops.secrets.email_password.path
          ];
          imap.authentication = "plain";
          smtp.authentication = "plain";
          himalaya.enable = true;
        };

        programs.himalaya.enable = true;

        # Shares ~/.config/himalaya/config.toml with the CLI
        home.packages = [ inputs.himalaya-tui.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };
    };
}
