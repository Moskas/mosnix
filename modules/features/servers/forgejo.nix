{
  flake.nixosModules.forgejo =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      cfg = config.services.forgejo;

      monoFont = config.moskas.fonts.mono;
      fontDir = "${monoFont.package}/share/fonts/truetype/NerdFonts/Terminess";

      # Forgejo serves custom/public/assets at /assets; theme files are picked up by name
      # from css/theme-<name>.css once listed in ui.THEMES
      themeCss = pkgs.writeText "theme-stylix.css" (
        with config.lib.stylix.colors.withHashtag;
        let
          mix =
            color: pct: base:
            "color-mix(in srgb, ${color} ${toString pct}%, ${base})";
          alpha = color: pct: mix color pct "transparent";
          alphaScale =
            name: color:
            lib.concatMapStrings (pct: "--color-${name}-alpha-${toString pct}: ${alpha color pct};\n") [
              10
              20
              30
              40
              50
              60
              70
              80
              90
            ];
          # Forgejo's palette names mapped to the base16 accents
          accents = {
            red = base08;
            orange = base09;
            yellow = base0A;
            olive = base0B;
            green = base0B;
            teal = base0C;
            blue = base0D;
            violet = base0E;
            purple = base0E;
            pink = base0E;
            brown = base0F;
          };
          accentVars = lib.concatStrings (
            lib.mapAttrsToList (name: color: ''
              --color-${name}: ${color};
              --color-${name}-light: ${color};
              --color-${name}-dark-1: ${mix color 85 base00};
              --color-${name}-dark-2: ${mix color 70 base00};
            '') accents
          );
          badge = name: color: ''
            --color-${name}-badge: ${color};
            --color-${name}-badge-bg: ${alpha color 13};
            --color-${name}-badge-hover-bg: ${alpha color 27};
          '';
          message = name: color: ''
            --color-${name}-border: ${mix color 50 base00};
            --color-${name}-bg: ${mix color 20 base00};
            --color-${name}-text: ${color};
          '';
        in
        ''
          /* Keeps the dark chroma/codemirror/markup imports and anything not overridden below */
          @import "./theme-forgejo-dark.css";

          @font-face {
            font-family: "${monoFont.name}";
            font-weight: 400;
            font-display: swap;
            src:
              local("${monoFont.name}"),
              local("TerminessNF"),
              url("/assets/fonts/mono-regular.ttf") format("truetype");
          }

          @font-face {
            font-family: "${monoFont.name}";
            font-weight: 700;
            font-display: swap;
            src:
              local("${monoFont.name} Bold"),
              local("TerminessNF-Bold"),
              url("/assets/fonts/mono-bold.ttf") format("truetype");
          }

          :root {
            --is-dark-theme: true;
            color-scheme: dark;

            --fonts-override: "${monoFont.name}", monospace;
            --fonts-monospace: "${monoFont.name}", monospace, var(--fonts-emoji);

            --border-radius: 0;
            --border-radius-medium: 0;
            --border-radius-large: 0;

            --color-primary: ${base0A};
            --color-primary-contrast: ${base00};
            --color-primary-dark-1: ${mix base0A 85 base07};
            --color-primary-dark-2: ${mix base0A 85 base07};
            --color-primary-dark-3: ${mix base0A 70 base07};
            --color-primary-dark-4: ${mix base0A 70 base07};
            --color-primary-dark-5: ${mix base0A 55 base07};
            --color-primary-dark-6: ${mix base0A 55 base07};
            --color-primary-dark-7: ${mix base0A 40 base07};
            --color-primary-light-1: ${base09};
            --color-primary-light-2: ${mix base09 85 base00};
            --color-primary-light-3: ${mix base09 70 base00};
            --color-primary-light-4: ${mix base09 55 base00};
            --color-primary-light-5: ${mix base09 55 base00};
            --color-primary-light-6: ${mix base09 40 base00};
            --color-primary-light-7: ${mix base09 40 base00};
            ${alphaScale "primary" base0A}
            --color-secondary: ${base02};
            --color-secondary-dark-1: ${base03};
            --color-secondary-dark-2: ${base03};
            --color-secondary-dark-3: ${base04};
            --color-secondary-dark-4: ${base04};
            --color-secondary-dark-5: ${base04};
            --color-secondary-dark-6: ${base05};
            --color-secondary-dark-7: ${base05};
            --color-secondary-dark-8: ${base05};
            --color-secondary-dark-9: ${base06};
            --color-secondary-dark-10: ${base06};
            --color-secondary-dark-11: ${base07};
            --color-secondary-dark-12: ${base07};
            --color-secondary-dark-13: ${base07};
            --color-secondary-light-1: ${base02};
            --color-secondary-light-2: ${base01};
            --color-secondary-light-3: ${base01};
            --color-secondary-light-4: ${base00};
            ${alphaScale "secondary" base02}
            ${accentVars}
            --color-grey: ${base03};
            --color-grey-light: ${base04};
            --color-black: ${base00};
            --color-black-light: ${base01};
            --color-black-dark-1: ${base00};
            --color-black-dark-2: ${base00};
            --color-gold: ${base0A};
            --color-white: ${base07};

            --color-console-fg: ${base05};
            --color-console-fg-subtle: ${base04};
            --color-console-bg: ${base00};
            --color-console-border: ${base02};
            --color-console-hover-bg: ${base01};
            --color-console-active-bg: ${base02};
            --color-console-menu-bg: ${base01};
            --color-console-menu-border: ${base02};

            --color-ansi-black: ${base00};
            --color-ansi-red: ${base08};
            --color-ansi-green: ${base0B};
            --color-ansi-yellow: ${base0A};
            --color-ansi-blue: ${base0D};
            --color-ansi-magenta: ${base0E};
            --color-ansi-cyan: ${base0C};
            --color-ansi-white: ${base05};
            --color-ansi-bright-black: ${base03};
            --color-ansi-bright-red: ${base08};
            --color-ansi-bright-green: ${base0B};
            --color-ansi-bright-yellow: ${base0A};
            --color-ansi-bright-blue: ${base0D};
            --color-ansi-bright-magenta: ${base0E};
            --color-ansi-bright-cyan: ${base0C};
            --color-ansi-bright-white: ${base07};

            --color-diff-removed-word-bg: ${mix base08 35 base00};
            --color-diff-added-word-bg: ${mix base0B 35 base00};
            --color-diff-removed-row-bg: ${mix base08 15 base00};
            --color-diff-moved-row-bg: ${mix base0A 15 base00};
            --color-diff-added-row-bg: ${mix base0B 15 base00};
            --color-diff-removed-row-border: ${mix base08 35 base00};
            --color-diff-moved-row-border: ${mix base0A 35 base00};
            --color-diff-added-row-border: ${mix base0B 35 base00};
            --color-diff-inactive: ${base01};

            ${message "error" base08}
            --color-error-bg-active: ${mix base08 30 base00};
            --color-error-bg-hover: ${mix base08 30 base00};
            ${message "success" base0B}
            ${message "warning" base0A}
            ${message "info" base0D}
            ${badge "red" base08}
            ${badge "green" base0B}
            ${badge "yellow" base0A}
            ${badge "orange" base09}

            --color-body: ${base00};
            --color-box-header: ${base01};
            --color-box-body: ${base00};
            --color-box-body-highlight: ${base01};
            --color-text-dark: ${base07};
            --color-text: ${base05};
            --color-text-light: ${base04};
            --color-text-light-1: ${base04};
            --color-text-light-2: ${base04};
            --color-text-light-3: ${base03};
            --color-footer: ${base00};
            --color-timeline: ${base02};
            --color-input-text: ${base05};
            --color-input-background: ${base01};
            --color-input-toggle-background: ${base02};
            --color-input-border: ${base02};
            --color-input-border-hover: ${base03};
            --color-header-wrapper: ${base01};
            --color-header-wrapper-transparent: ${alpha base01 0};
            --color-light-border: ${base02};
            --color-hover: ${base02};
            --color-active: ${base02};
            --color-menu: ${base01};
            --color-card: ${base01};
            --fancy-card-bg: ${base01};
            --fancy-card-border: ${base02};
            --color-markup-table-row: ${alpha base01 50};
            --color-markup-code-block: ${base01};
            --color-markup-code-inline: ${base01};
            --color-button: ${base01};
            --color-code-bg: ${base00};
            --color-shadow: ${alpha base00 50};
            --color-secondary-bg: ${base01};
            --color-text-focus: ${base07};
            --color-expand-button: ${base02};
            --color-editor-line-highlight: ${base01};
            --color-reaction-bg: ${base01};
            --color-tooltip-text: ${base05};
            --color-tooltip-bg: ${base01};
            --color-nav-bg: ${base00};
            --color-nav-hover-bg: ${base01};
            --color-label-text: ${base05};
            --color-label-bg: ${base02};
            --color-label-hover-bg: ${base03};
            --color-label-active-bg: ${base03};
            --color-label-bg-alt: ${base03};
            --color-accent: ${base0A};
            --color-small-accent: ${mix base0A 55 base00};
            --color-highlight-fg: ${base0A};
            --color-highlight-bg: ${alpha base0A 20};
            --color-overlay-backdrop: ${alpha base00 75};
            --color-selection-bg: ${base02};
            --color-selection-fg: ${base07};
            --checkerboard-color-1: ${base02};
            --color-indicator-idle: ${base0B};
            --color-indicator-active: ${base0D};
            --checkerboard-color-2: ${base01};
          }

          /* Terminus bitmap strikes at 14px and 18px are a pixel wider per glyph than the outline
             metrics used for layout, which clips text; keep to sizes where the two agree */
          html,
          body {
            font-size: ${toString config.moskas.fonts.sizes.desktop}px;
          }

          .comment-code-cloud .ui.tab.markup,
          .repository.new.issue .comment.form .content .markup,
          .issue-state-label,
          .repository.view.issue .comment-list .comment .markup,
          .repository.compare.pull .markup,
          .repository .diff-box .resolved-placeholder,
          .issue-card-title {
            font-size: ${toString config.moskas.fonts.sizes.desktop}px !important;
          }

          .repository.tags #tags-table .release-tag-name,
          .job-artifacts-title {
            font-size: 16px !important;
          }

          #navbar {
            border-bottom: 1px solid ${base02};
          }

          i.grey.icon.icon.icon.icon {
            color: ${base04} !important;
          }

          .ui.secondary.vertical.menu {
            border-radius: 0 !important;
          }

          /* Syntax highlighting on top of the forgejo-dark chroma palette */
          .chroma .c, .chroma .c1, .chroma .ch, .chroma .cm, .chroma .cs, .chroma .go {
            color: ${base03};
          }
          .chroma .k, .chroma .kd, .chroma .kr, .chroma .kn, .chroma .kp, .chroma .ow {
            color: ${base0E};
          }
          .chroma .kt, .chroma .nc, .chroma .ne {
            color: ${base0A};
          }
          .chroma .s, .chroma .s1, .chroma .s2, .chroma .sb, .chroma .sc, .chroma .sd, .chroma .sh,
          .chroma .sr, .chroma .ss, .chroma .sx, .chroma .dl {
            color: ${base0B};
          }
          .chroma .se, .chroma .si {
            color: ${base0C};
          }
          .chroma .m, .chroma .mb, .chroma .mf, .chroma .mh, .chroma .mi, .chroma .il, .chroma .mo,
          .chroma .kc, .chroma .no {
            color: ${base09};
          }
          .chroma .nf, .chroma .fm, .chroma .nd {
            color: ${base0D};
          }
          .chroma .nb, .chroma .bp, .chroma .cp, .chroma .cpf {
            color: ${base0C};
          }
          .chroma .nt, .chroma .nv, .chroma .vc, .chroma .vg, .chroma .vi {
            color: ${base08};
          }
          .chroma .na {
            color: ${base0A};
          }
          .chroma .o, .chroma .p, .chroma .n, .chroma .nx {
            color: ${base05};
          }
          .chroma .gd {
            color: ${base08};
            background-color: ${mix base08 15 base00};
          }
          .chroma .gi {
            color: ${base0B};
            background-color: ${mix base0B 15 base00};
          }
          .chroma .gh, .chroma .gu {
            color: ${base0D};
          }
          .chroma .err, .chroma .gr {
            color: ${base08};
          }
        ''
      );

      themeFonts = pkgs.linkFarm "forgejo-fonts" [
        {
          name = "mono-regular.ttf";
          path = "${fontDir}/TerminessNerdFont-Regular.ttf";
        }
        {
          name = "mono-bold.ttf";
          path = "${fontDir}/TerminessNerdFont-Bold.ttf";
        }
      ];

      # Stylix overlays nixos-icons with a recolored snowflake; the PNGs cover OpenGraph and
      # touch icons, which can't use SVG
      themeImages =
        let
          snowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        in
        pkgs.runCommand "forgejo-images" { nativeBuildInputs = [ pkgs.librsvg ]; } ''
          mkdir $out
          cp ${snowflake} $out/logo.svg
          cp ${snowflake} $out/favicon.svg
          rsvg-convert -w 512 -h 512 -a ${snowflake} -o $out/logo.png
          rsvg-convert -w 180 -h 180 -a ${snowflake} -o $out/favicon.png
          rsvg-convert -w 180 -h 180 -a ${snowflake} -o $out/apple-touch-icon.png
        '';

      # Shown under the app name on the landing page; it's the translated `startpage.app_desc`
      # string rather than a setting, so every locale that defines it gets patched
      appDesc = "Reproducible purrs. Chaotic meows.";

      # A custom locale file replaces the built-in one whole, so start from the package's copies
      locales =
        pkgs.runCommand "forgejo-locales"
          {
            nativeBuildInputs = [ pkgs.gawk ];
            inherit appDesc;
          }
          ''
            mkdir $out
            for f in ${cfg.package.src}/options/locale/*.ini; do
              awk '/^app_desc *=/ { print "app_desc = " ENVIRON["appDesc"]; next } { print }' \
                "$f" > "$out/$(basename "$f")"
            done
          '';

      homeIntro = "Self-hosted home for my personal projects and NixOS configuration.";
      homeProjects = map (name: "Moskas/${name}") [
        "shinbun"
        "mangars"
        "kojin"
        "dendritic-nix"
      ];

      # Replaces the feature blurbs below the logo and slogan. Templates can't look up a repo by
      # name, so avatars and descriptions are filled in from the API, keeping the repo icon when
      # a repo has no avatar or isn't visible to the viewer
      homeTemplate = pkgs.writeText "home_forgejo.tmpl" ''
        <style>
          .home-projects {
            max-width: 880px;
            margin: 0 auto 3rem;
            padding: 0 2rem;
            text-align: center;
          }
          .home-projects-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
            text-align: start;
          }
          .home-project {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border: 1px solid var(--color-secondary);
            border-radius: var(--border-radius);
            background: var(--color-box-body);
            color: var(--color-text);
          }
          .home-project:hover {
            background: var(--color-hover);
            color: var(--color-text);
            text-decoration: none;
          }
          .home-project-avatar {
            display: flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            color: var(--color-text-light);
          }
          .home-project-avatar img {
            width: 48px;
            height: 48px;
            border-radius: var(--border-radius);
            object-fit: cover;
          }
          .home-project-name {
            display: block;
            color: var(--color-primary);
            font-weight: 700;
          }
          .home-project-desc {
            display: block;
            color: var(--color-text-light);
          }
        </style>
        <div class="home-projects">
          <p class="large">${homeIntro}</p>
          <div class="home-projects-grid">
            ${lib.concatMapStrings (repo: ''
              <a class="home-project" href="{{AppSubUrl}}/${repo}" data-api="{{AppSubUrl}}/api/v1/repos/${repo}">
                <span class="home-project-avatar">{{svg "octicon-repo" 32}}</span>
                <span>
                  <span class="home-project-name">${lib.last (lib.splitString "/" repo)}</span>
                  <span class="home-project-desc"></span>
                </span>
              </a>
            '') homeProjects}
          </div>
        </div>
        <script>
          for (const el of document.querySelectorAll(".home-project[data-api]")) {
            fetch(el.dataset.api)
              .then((res) => (res.ok ? res.json() : null))
              .then((repo) => {
                if (!repo) return;
                if (repo.avatar_url) {
                  const img = document.createElement("img");
                  img.src = repo.avatar_url;
                  img.alt = "";
                  el.querySelector(".home-project-avatar").replaceChildren(img);
                }
                el.querySelector(".home-project-desc").textContent = repo.description;
              })
              .catch(() => {});
          }
        </script>
      '';

      themeDir = {
        d = {
          inherit (cfg) user group;
          mode = "0750";
        };
      };

      # From Site Administration > Actions > Runners > Create new runner; the matching token goes
      # into sops as `forgejo_runner_token`. The runner stays off until this is set
      runnerUuid = "1e272706-6008-47ce-b9ac-060091b73ba8";

      # Default job environment: a Nix client for the host daemon plus what JS actions like
      # actions/checkout expect to find. Builds land in laffey's store, so harmonia serves them
      runnerImageRef = "localhost/forgejo-nix:latest";

      # Out-links of CI builds, keeping the latest build of each host alive for harmonia
      ciRootsDir = "/var/lib/ci-roots";
      runnerContents = [
        config.nix.package
        pkgs.bashInteractive
        pkgs.coreutils
        pkgs.findutils
        pkgs.gnugrep
        pkgs.gnused
        pkgs.gnutar
        pkgs.gzip
        pkgs.xz
        pkgs.gitMinimal
        pkgs.nodejs
        pkgs.curl
        pkgs.cacert
        pkgs.dockerTools.usrBinEnv
        pkgs.dockerTools.binSh
        pkgs.dockerTools.caCertificates
        pkgs.dockerTools.fakeNss
        # Substituters and sandboxing come from the daemon's own config
        (pkgs.writeTextDir "etc/nix/nix.conf" ''
          experimental-features = nix-command flakes
          store = daemon
        '')
      ];
      # Host paths bind-mounted into every job container
      runnerMounts = [
        "/nix/store:/nix/store:ro"
        "/nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket"
        # Mounted at the same path so the daemon's indirect roots resolve on the host
        "${ciRootsDir}:${ciRootsDir}"
      ];
      runnerImage = pkgs.dockerTools.buildLayeredImage {
        name = "forgejo-nix";
        tag = "latest";
        contents = runnerContents;
        extraCommands = ''
          mkdir -p tmp root
          chmod 1777 tmp
        '';
        config.Env = [
          "PATH=/bin:/usr/bin"
          "HOME=/root"
          "USER=root"
          "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
          "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
        ];
      };
    in
    {
      config = lib.mkMerge [
        {
          services.forgejo = {
            enable = true;
            package = pkgs.forgejo;
            settings = {
              # Forgejo reads these from the top of app.ini, outside any section
              DEFAULT = {
                APP_NAME = "Neko Forge 🐈‍⬛";
              };
              server = {
                DOMAIN = "git.taila32e5.ts.net";
                ROOT_URL = "https://git.taila32e5.ts.net/";
                HTTP_ADDR = "127.0.0.1";
                HTTP_PORT = 3000;
                # git-over-SSH does not pass through tsnsrv; use the real host node.
                SSH_DOMAIN = "${config.networking.hostName}.taila32e5.ts.net";
              };
              ui = {
                DEFAULT_THEME = "stylix";
                THEMES = lib.concatStringsSep "," [
                  "stylix"
                  "forgejo-auto"
                  "forgejo-light"
                  "forgejo-dark"
                ];
              };
              actions = {
                ENABLED = true;
                DEFAULT_ACTIONS_URL = "github";
              };
            };
          };
          systemd = {
            tmpfiles.settings."10-forgejo-theme" = {
              "${cfg.customDir}/public" = themeDir;
              "${cfg.customDir}/public/assets" = themeDir;
              "${cfg.customDir}/public/assets/css" = themeDir;
              "${cfg.customDir}/public/assets/css/theme-stylix.css"."L+".argument = "${themeCss}";
              "${cfg.customDir}/public/assets/fonts"."L+".argument = "${themeFonts}";
              "${cfg.customDir}/public/assets/img"."L+".argument = "${themeImages}";
              "${cfg.customDir}/templates" = themeDir;
              "${cfg.customDir}/templates/home_forgejo.tmpl"."L+".argument = "${homeTemplate}";
              "${cfg.customDir}/options" = themeDir;
              "${cfg.customDir}/options/locale"."L+".argument = "${locales}";
            };

            # Templates are parsed once at startup, unlike the static assets above
            services.forgejo.restartTriggers = [
              homeTemplate
              locales
            ];
          };
        }

        (lib.mkIf (runnerUuid != null) {
          virtualisation.podman = {
            enable = true;
            # Plain prune only drops dangling layers, so the tagged job image stays
            autoPrune.enable = true;
          };

          # Jobs get a private user namespace, so their root reaches the nix-daemon as an
          # unprivileged uid instead of a trusted user. Set here because the runner's
          # --userns option only accepts "host"; podman runs nothing but jobs on this host
          virtualisation.containers.containersConf.settings.containers.userns = "auto";
          users = {
            users.containers = {
              isSystemUser = true;
              group = "containers";
              subUidRanges = [
                {
                  startUid = 2147483647;
                  count = 2147483648;
                }
              ];
              subGidRanges = [
                {
                  startGid = 2147483647;
                  count = 2147483648;
                }
              ];
            };
            groups.containers = { };
          };

          # The job image's tools run from the host store mount, so keep them from being collected
          system.extraDependencies = runnerContents;

          sops.secrets.forgejo_runner_token = { };

          services.forgejo-runner.instances.default = {
            enable = true;
            settings = {
              runner.labels = [
                "nixos-latest:docker://${runnerImageRef}"
                "nixos:docker://${runnerImageRef}"
                "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-24.04"
                "ubuntu-24.04:docker://ghcr.io/catthehacker/ubuntu:act-24.04"
                "ubuntu-22.04:docker://ghcr.io/catthehacker/ubuntu:act-22.04"
              ];
              container = {
                # Evaluation runs in the job's nix client, outside the daemon's limits;
                # `nix flake check` across all hosts peaks around 9G
                options = lib.concatStringsSep " " (
                  [ "--memory=10g" ] ++ map (mount: "--volume ${mount}") runnerMounts
                );
                # Binds from options are dropped unless their source is listed here
                valid_volumes = map (mount: lib.head (lib.splitString ":" mount)) runnerMounts;
              };
              server.connections.default = {
                # Jobs reuse this URL for checkout and the API, so it has to resolve from inside
                # their containers too; they reach the tsnsrv node through laffey's tailscale
                url = cfg.settings.server.ROOT_URL;
                uuid = runnerUuid;
              };
            };
            secrets.server.connections.default.token_url = config.sops.secrets.forgejo_runner_token.path;
          };

          # Jobs run as varying userns uids, so no sticky bit: any job must be able to replace
          # the previous build's out-link
          systemd.tmpfiles.settings."10-ci-roots".${ciRootsDir}.d.mode = "0777";

          systemd.services = {
            # Loaded rather than pulled; reloading on change retags `latest` onto the new image
            forgejo-runner-nix-image = {
              description = "Load the Nix job image for forgejo-runner";
              requiredBy = [ "forgejo-runner-default.service" ];
              before = [ "forgejo-runner-default.service" ];
              path = [ config.virtualisation.podman.package ];
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
              };
              script = "podman load --input ${runnerImage}";
            };

            # The module adds the podman group but leaves the runner looking for docker.sock.
            # container.docker_host stays unset so job containers don't get the socket mounted
            forgejo-runner-default.environment.DOCKER_HOST = "unix:///run/podman/podman.sock";
          };
        })
      ];
    };
}
