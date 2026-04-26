{
  flake.nixosModules.samba = {
    config = {
      services.samba = {
        enable = true;
        securityType = "user";
        openFirewall = true;
        settings = {
          global = {
            "invalid users" = [ "root" ];
            "passwd program" = "/run/wrappers/bin/passwd %u";
            security = "user";
          };
          media = {
            browseable = "yes";
            "guest ok" = "yes";
            path = "/media";
            "read only" = "no";
          };
          shared = {
            browseable = "yes";
            "guest ok" = "yes";
            path = "/mnt/disk2";
            "read only" = "no";
          };
          moskas = {
            browsable = "yes";
            "valid users" = "moskas";
            path = "/home/moskas";
            "read only" = "no";
          };
        };
      };
      services.samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
