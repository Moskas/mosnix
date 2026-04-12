{
  flake.nixosModules.common = {
    config = {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          LoginGraceTime = 0;
          X11Forwarding = true;
        };
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
