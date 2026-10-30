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
        # knownHosts = {
        #   cheshire = {
        #     hostNames = [ "cheshire" ];
        #     publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcyn8bcHt95Md8h93x630f2gfsTqaiwHXDyvu+iyuKW";
        #   };
        #   noshiro = {
        #     hostNames = [ "noshiro" ];
        #     publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqY9eUP1BDb71ejfs/a6AZN02VGtNqapu3ttCcmPo98";
        #   };
        # };
      };

      users.users.moskas.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcyn8bcHt95Md8h93x630f2gfsTqaiwHXDyvu+iyuKW moskas@cheshire"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpoSvwjWLgKtwr9e/VEsh2fNw39aEsSdSUdqxCEqFYQ moskas@roon"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwxli8p6YHNTHlr+LYrYELUMfyNg8mwLtqGgcMy4FIa nix-on-droid@boise"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOqhJIblbfCgvzBAetg9qzlHyL19hiqMdKwPnc9MJIuM moskas@shimakaze"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqY9eUP1BDb71ejfs/a6AZN02VGtNqapu3ttCcmPo98 moskas@noshiro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChr50iFARqmJBKcPe+LdNvDnO0bza9ImKmYPlcT8CBi u0_a442@localhost"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGICKZja7UpBN4XgLALba57OQKJY1n1YodatdXjiEIGD moskas@glasgow"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHTEit4avXKGhETGMQxNNf5Xf8Q3Pl+kR2e31ZmJcHX/ moskas@kashino"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvzIDAIwHCX2msDthWWOLHVAPvGJ1PpROZvo47H53Wm moskas@akashi"
      ];

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };
}
