{ pkgs, lib, ... }:
{
  flake.homeModules.qutebrowser = {
    programs.qutebrowser = {
      enable = true;
      searchEngines = {
        DEFAULT = "https://startpage.com/search?q={}";
        wi = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = "https://wiki.archlinux.org/?search={}";
        np = "https://search.nixos.org/packages?&query={}";
        no = "https://search.nixos.org/options?&query={}";
        nw = "https://nixos.wiki/index.php?search={}";
        hm = "https://home-manager-options.extranix.com/?query={}";
        gg = "https://www.google.com/search?hl=en&q={}";
        br = "https://search.brave.com/search?q={}";
        st = "https://startpage.com/search?q={}";
        ec = "https://ecosia.org/search?&q={}";
        dc = "https://docs.rs/releases/search?query={}";
        aa = "https://annas-archive.gl/search?q={}";
        yt = "https://www.youtube.com/results?search_query={}";
        gu = "https://github.com/search?q={}&type=users";
        gr = "https://github.com/search?q={}&type=repos";
      };
      settings = {
        colors.webpage.darkmode.enabled = lib.mkForce false;
        auto_save.session = true;
        statusbar.show = "in-mode";
        downloads.position = "bottom";
        editor = {
          command = [ "$EDITOR {file}" ];
        };
        content = {
          autoplay = false;
          blocking = {
            enabled = true;
            method = "both";
            adblock.lists = [
              "https://easylist.to/easylist/easylist.txt"
              "https://easylist.to/easylist/easyprivacy.txt"
              "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt"
              "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
              "https://www.i-dont-care-about-cookies.eu/abp/"
              "https://raw.githubusercontent.com/piperun/iploggerfilter/master/filterlist"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt"
              "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt"
            ];
            hosts.lists = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts"
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling/hosts"
              "https://curbengh.github.io/malware-filter/urlhaus-filter-online.txt"
            ];
          };
          tabs = {
            show = "multiple";
            show_switching_delay = 1500;
            background = true;
            title.format = "{audio}{current_title}";
            padding = {
              bottom = 5;
              left = 5;
              right = 5;
              top = 5;
            };
          };
          scrolling.smooth = true;
          url = {
            start_pages = "http://laffey/";
            default_page = "https://www.startpage.com";
          };
          content.blocking.whitelist = [
            "*://xeiaso.net/*"
            "*://ethicalads.io/*"
            "*://*.ethicalads.io/*"
          ];
        };
        keyBindings = {
          normal = {
            "e" = "cmd-set-text :open -r {url:pretty}";
            "wt" = "spawn mpv {url}";
            ",p" = "spawn --userscript qute-bitwarden";
            ",u" = "adblock-update";
            ",l" = ''config-cycle spellcheck.languages ["en-GB"] ["en-US"] ["pl-PL"]'';
            "wd" = "hint links spawn kitty -e ${pkgs.yt-dlp}/bin/yt-dlp {hint-url}"; # make it more terminal agnostic
            "ww" = "hint links spawn --detach mpv {hint-url}";
            "ws" = "hint links spawn --detach ${pkgs.streamlink}/bin/streamlink {hint-url} best --player mpv";
            "q" = "tab-close";
            "J" = "tab-prev";
            "K" = "tab-next";
          };
          prompt = {
            "<Ctrl-y>" = "prompt-yes";
          };
        };
        extraConfig = ''
          config.unbind('d')
          c.fileselect.handler = "external"
          c.fileselect.folder.command = ['kitty', '--class', 'ranger,ranger', '-e', 'ranger', '--choosefile', '{}']
          c.fileselect.single_file.command = ['kitty', '--class', 'ranger,ranger', '-e', 'ranger', '--choosefile', '{}']
          c.fileselect.multiple_files.command = ['kitty', '--class', 'ranger,ranger', '-e', 'ranger', '--choosefile', '{}']
        '';
      };
    };
  };
}
