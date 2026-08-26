{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/home/moskas/.config/sops/age/keys.txt";
    secrets = {
      "laffey_runner" = {
        mode = "0400";
      };
      "attic_token" = {
        mode = "0400";
      };
    };
  };
}
