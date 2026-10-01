{ inputs, ... }:
{
  flake.nixosModules.kojin =
    { config, pkgs, ... }:
    let
      # content/ is checked into the kojin repo (git-tracked, static) so it's
      # fine to bake into the store; only cache/ (gitignored, regenerated
      # image thumbnails) and kojin.db are real runtime state, so cache/ is
      # replaced with a symlink into the writable StateDirectory.
      kojinPackage = pkgs.bun2nix.mkDerivation {
        pname = "kojin";
        version = "0.1.0";
        src = inputs.kojin;

        # autoPatchElf is NOT set here: fetchBunDeps applies it uniformly to
        # every platform variant in the lockfile's optionalDependencies,
        # including sharp builds for musl/darwin/etc. that this glibc NixOS
        # box will never use — those fail to patch (missing musl libc) with
        # no per-package way to skip them. Patching instead happens below,
        # after bun's real install has already filtered node_modules down to
        # only the platform-matching packages.
        bunDeps = pkgs.bun2nix.fetchBunDeps {
          # Not bun.nix: this dendritic flake's importTree auto-imports every
          # *.nix file under the repo as a flake-parts module, which breaks
          # on this plain { fetchurl, ... }: function. Kept out of that scan
          # by using a non-.nix final extension.
          bunNix = ./kojin-pkg/bun-deps.nix.inc;
        };

        # sharp's own libvips (@img/sharp-libvips-linux-x64) ships alongside
        # it in node_modules, but autoPatchelfHook doesn't search sibling
        # package dirs; nixpkgs' vips ships the exact same soname (42), so
        # link against that instead.
        nativeBuildInputs = [
          pkgs.autoPatchelfHook
          pkgs.stdenv.cc.cc.lib
          pkgs.vips
        ];

        dontUseBunBuild = true;
        dontUseBunCheck = true;
        dontFixup = false;

        # bun's isolated linker keeps every optionalDependencies platform
        # variant physically present under node_modules/.bun/ (musl, darwin,
        # etc.), not just the one actually used at runtime; autoPatchelfHook
        # scans all of them regardless. musl libc genuinely isn't available
        # in nixpkgs under this soname, so ignore it rather than chase it.
        autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

        installPhase = ''
          runHook preInstall
          mkdir -p $out
          cp -r . $out
          rm -rf $out/cache
          ln -s /var/lib/kojin/cache $out/cache
          runHook postInstall
        '';
      };
    in
    {
      nixpkgs.overlays = [ inputs.bun2nix.overlays.default ];

      users.users.kojin = {
        isSystemUser = true;
        group = "kojin";
      };
      users.groups.kojin = { };

      sops.secrets.kojin_lastfm_api_key = {
        mode = "0400";
        owner = "kojin";
      };

      systemd.services.kojin = {
        description = "kojin personal website";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          PORT = "3000";
          SITE_URL = "https://moskas.space";
          SITE_AUTHOR = "Moskas";
          DB_PATH = "/var/lib/kojin/kojin.db";
          LASTFM_USERNAME = "MoskasPlay";
          ANILIST_USER_ID = "241803";
        };

        serviceConfig = {
          Type = "simple";
          User = "kojin";
          Group = "kojin";
          # kojin/cache creates /var/lib/kojin/cache too, the target of the
          # symlink baked into kojinPackage at build time.
          StateDirectory = "kojin kojin/cache";
          WorkingDirectory = kojinPackage;
          # sops secret content must be the literal line `LASTFM_API_KEY=...`
          # so it can be loaded directly as an EnvironmentFile. Optional (`-`
          # prefix) because the secret doesn't exist until the sops bootstrap
          # pass (host age key added, secrets.yaml re-encrypted) runs.
          EnvironmentFile = "-${config.sops.secrets.kojin_lastfm_api_key.path}";
          ExecStart = "${pkgs.bun}/bin/bun run src/server.tsx";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      security.acme = {
        acceptTerms = true;
        defaults.email = "CHANGEME@example.com"; # TODO: set the real ACME contact email
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        appendHttpConfig = ''
          limit_req_zone $binary_remote_addr zone=kojin_global:10m  rate=30r/s;
          limit_req_zone $binary_remote_addr zone=kojin_search:10m  rate=3r/s;
          limit_req_zone $binary_remote_addr zone=kojin_photos:10m  rate=5r/s;
          limit_req_zone $binary_remote_addr zone=kojin_img:10m     rate=10r/s;
        '';
        virtualHosts."moskas.space" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
            extraConfig = "limit_req zone=kojin_global burst=50 nodelay;";
          };
          locations."/search" = {
            proxyPass = "http://127.0.0.1:3000";
            extraConfig = ''
              limit_req zone=kojin_search burst=5 nodelay;
              limit_req zone=kojin_global burst=50 nodelay;
            '';
          };
          locations."/photos" = {
            proxyPass = "http://127.0.0.1:3000";
            extraConfig = ''
              limit_req zone=kojin_photos burst=5 nodelay;
              limit_req zone=kojin_global burst=50 nodelay;
            '';
          };
          locations."/photos/img/" = {
            proxyPass = "http://127.0.0.1:3000";
            extraConfig = ''
              limit_req zone=kojin_img burst=20 nodelay;
              limit_req zone=kojin_global burst=50 nodelay;
            '';
          };
        };
      };

      services.fail2ban = {
        enable = true;
        jails = {
          kojin-ratelimit.settings = {
            enabled = true;
            port = "http,https";
            filter = "kojin-ratelimit";
            logpath = "/var/log/nginx/access.log";
            maxretry = 10;
            findtime = 60;
            bantime = 3600;
          };
          nginx-botsearch.settings = {
            enabled = true;
            port = "http,https";
            filter = "nginx-botsearch";
            logpath = "/var/log/nginx/access.log";
            maxretry = 5;
            findtime = 60;
            bantime = 86400;
          };
        };
      };

      environment.etc."fail2ban/filter.d/kojin-ratelimit.conf".text = ''
        [Definition]
        failregex = ^<HOST> .* "(GET|POST|HEAD) .* HTTP/.*" 429
        ignoreregex =
      '';
    };
}
