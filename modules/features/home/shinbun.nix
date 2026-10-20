{
  flake.homeModules.shinbun = { inputs, ... }: {
    imports = [ inputs.shinbun.homeManagerModules.default ];
    config = {
      programs.shinbun = {
        enable = true;
        feeds = [
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCMiyV_Ib77XLpzHPQH_q0qQ";
            name = "Veronica Explains";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCsnGwSIHyoYN0kiINAGUKxg";
            name = "Wolfgang";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UC5UAwBUum7CPN5buc-_N1Fw";
            name = "TheLinuxExperiment";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCR-DXc1voovS8nhAvccRZhg";
            name = "Jeff Geerling";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCruD32HAzsb9UN4KpOcSxZg";
            name = "London Eats";
            tags = [ "Youtube" ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCC_NjLEb2Sley94py4vSYTA";
            name = "Andres Vidoza";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCCQ6SXMc7MoJ88jjpn6j-8Q";
            name = "Marko";
            tags = [
              "Youtube"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCnn3N0i3TVGbQ9bMb4ln2OQ";
            name = "Kyle Erickson";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCAiiOTio8Yu69c3XnR7nQBQ";
            name = "System Crafters";
            tags = [
              "Youtube"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UC2hi12ngz1aiGv_vditVHGw";
            name = "Brandon Boswell";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCvfUcuSDNOoFsAPsiGdaGPg";
            name = "Notebook Check";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCxQKHvKbmSzGMvUrVtJYnUA";
            name = "Learn Linux TV";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCLuJuI0M95qWsVw_KQOkTgQ";
            name = "Pinsplash";
            tags = [
              "Youtube"
              "Games"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJ6KZTTnkE-s2XFJJmoTAkw";
            name = "Accursed Farms";
            tags = [
              "Youtube"
              "Games"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCjREVt2ZJU8ql-NC9Gu-TJw";
            name = "Code to the Moon";
            tags = [
              "Youtube"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCNhWSOlt_UoCzS2YSMhHYmA";
            name = "Kai Notebook";
            tags = [ "Youtube" ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCLx053rWZxCiYWsBETgdKrQ";
            name = "LGR";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UC8uT9cgJorJPWu7ITLGo9Ww";
            name = "The 8-Bit Guy";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCerEIdrEW-IqwvlH8lTQUJQ";
            name = "Tech Tangents";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCoL8olX-259lS1N6QPyP4IQ";
            name = "Action Retro";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UC7yZ6keOGsvERMp2HaEbbXQ";
            name = "devaslife";
            tags = [
              "Youtube"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCUMwY9iS8oMyWDYIe6_RmoA";
            name = "No Boilerplate";
            tags = [
              "Youtube"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCnCmb1vpv90EeSX5g7K4UYQ";
            name = "The Librarian";
            tags = [
              "Youtube"
              "Games"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UC_zBdZ0_H_jn41FDRG7q4Tw";
            name = "Vimjoyer";
            tags = [
              "Youtube"
              "Nix"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UC6jUsIEZ2F875OB2Be84cpA";
            name = "Ampersand";
            tags = [
              "Youtube"
              "Nix"
              "Programming"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCbfg3_hFrOxuEtYMRGsp1ig";
            name = "myTerminal";
            tags = [
              "Youtube"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCBZA3z_u8LPiVuIo7YUdDcg";
            name = "Takuya Matsuyama (craftzdog)";
            tags = [
              "Youtube"
              "Programming"
              "Tech"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCv8DWjBD7B82I7vcnLciN0Q";
            name = "EIGA";
            tags = [
              "Youtube"
              "Tech"
              "Keyboards"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCdpkTMgFiDkcAnNV7TmXntA";
            name = "Cheese Turbulence";
            tags = [
              "Youtube"
              "Tech"
              "Keyboards"
            ];
          }
          {
            link = "https://www.youtube.com/feeds/videos.xml?channel_id=UCJAZvc_C5M4pR_SwK_0z0xg";
            name = "cloudyhills";
            tags = [
              "Youtube"
              "Design"
              "Cozy"
            ];
          }
          {
            link = "https://odysee.com/$/rss/@Urbandoned:5";
            name = "Urbandoned";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@AlphaNerd:8";
            name = "Mental Outlaw";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@bugswriter:8";
            name = "bugswriter";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@DistroTube:2";
            name = "DistroTube";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@BrodieRobertson:5";
            name = "BrodieRobertson";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@SomeOrdinaryGamers:a";
            name = "Mutahar";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@thelinuxcast:4";
            name = "TheLinuxCast";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@TheOpenBSDGuy:e";
            name = "The OpenBSD Guy";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@SwindlesMcCoop:1";
            name = "SwindlesMcCoop";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@adriansdigitalbasement:f";
            name = "Adrian's DB";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@fireship:6";
            name = "Fireship";
            tags = [
              "Odysee"
              "Tech"
              "Programming"
            ];
          }
          {
            link = "https://odysee.com/$/rss/@bryce:c";
            name = "Bryce Vandegrift";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@EmMerge:f";
            name = "Emilia Emerge";
            tags = [ "Odysee" ];
          }
          {
            link = "https://odysee.com/$/rss/@GavinFreeborn:d";
            name = "Gavin Freeborn";
            tags = [ "Odysee" ];
          }
          {
            link = "https://moskas.github.io/feed";
            tags = [ "Blog" ];
          }
          {
            link = "https://myme.no/atom-feed.xml";
            tags = [
              "Linux"
              "Tech"
              "Blog"
            ];
          }
          {
            link = "https://emacsredux.com/atom.xml";
            tags = [
              "Tech"
              "Emacs"
              "Blog"
            ];
          }
          {
            link = "https://emacstil.com/feed.xml";
            tags = [
              "Tech"
              "Emacs"
              "Blog"
            ];
          }
          {
            link = "https://irreal.org/blog/?feed=rss2";
            tags = [
              "Tech"
              "Emacs"
              "Blog"
            ];
          }
          {
            link = "https://mbork.pl/?action=rss;days=30;all=0;showedit=0;full=1";
            tags = [
              "Tech"
              "Emacs"
              "Blog"
            ];
          }
          {
            link = "https://morss.it/https://planet.emacslife.com/atom.xml";
            tags = [
              "Tech"
              "Emacs"
              "Blog"
            ];
          }
          {
            link = "https://xeiaso.net/blog.rss";
            tags = [
              "Tech"
              "Nix"
              "Blog"
            ];
          }
          {
            link = "https://0xda.de/blog/index.xml";
            tags = [
              "Nix"
              "Tech"
              "Blog"
            ];
          }
          {
            link = "https://blog.tiserbox.com/atom.xml";
            tags = [
              "Nix"
              "Blog"
              "Tech"
            ];
          }
          {
            link = "https://xn--gckvb8fzb.com/index.xml";
            tags = [
              "Tech"
              "Linux"
              "Privacy"
              "Blog"
            ];
          }
          {
            link = "https://wiki.xxiivv.com/links/log.xml";
            name = "xxiivv";
            tags = [ "Blog" ];
          }
          {
            link = "https://wiki.xxiivv.com/links/img.xml";
            name = "xxiivv - img";
            tags = [
              "Blog"
              "Img"
            ];
          }
          {
            link = "https://100r.co/links/rss.xml";
            tags = [ "Blog" ];
          }
          {
            link = "https://grimgrains.com/links/rss.xml";
            tags = [ "Cooking" ];
          }
          {
            link = "https://morss.it/https://determinate.systems/rss.xml";
            tags = [
              "Nix"
              "Blog"
            ];
          }
          {
            link = "https://thewagner.net/feeds/all.atom.xml";
            tags = [
              "Nix"
              "Programming"
              "Homelab"
              "Blog"
            ];
          }
          {
            link = "https://morss.it/https://jnsgr.uk/posts/index.xml";
            tags = [
              "Nix"
              "Blog"
            ];
          }
          {
            link = "https://morss.it/https://nixcademy.com/feed";
            tags = [
              "Nix"
              "Blog"
            ];
          }
          {
            link = "https://blog.rust-lang.org/feed.xml";
            tags = [
              "Blog"
              "Programming"
            ];
          }
          {
            link = "https://thelinuxexp.com/feed.xml";
            tags = [
              "Blog"
              "Linux"
            ];
          }
          {
            link = "https://thelinuxcast.org/feed/feed.xml";
            tags = [
              "Blog"
              "Linux"
            ];
          }
          {
            link = "https://morss.it/https://fabiensanglard.net/rss.xml";
            tags = [
              "Blog"
              "Linux"
              "Tech"
            ];
          }
          {
            link = "https://morss.it/https://panoptykon.org/rss.xml";
            tags = [
              "Blog"
              "Privacy"
            ];
          }
          {
            link = "https://zettelkasten.de/feed.atom";
            tags = [
              "Blog"
              "Notes"
            ];
          }
          {
            link = "https://blog.phundrak.com/index.xml";
            tags = [
              "Blog"
              "Tech"
              "Emacs"
            ];
          }
          {
            link = "https://vermaden.wordpress.com/feed";
            name = "vermaden";
            tags = [
              "Blog"
              "Tech"
              "BSD"
            ];
          }
          {
            link = "https://jcs.org/rss";
            name = "jcs";
            tags = [
              "Blog"
              "BSD"
              "Retro"
              "Programming"
            ];
          }
          {
            link = "https://programmershideaway.dev/atom.xml";
            tags = [
              "Blog"
              "Programming"
            ];
          }
          {
            link = "https://morss.it/https://www.jeffgeerling.com/blog.xml";
            tags = [
              "Blog"
              "Tech"
            ];
          }
          {
            link = "https://ploum.net/atom_en.xml";
            tags = [ "Blog" ];
          }
          {
            link = "https://haseebmajid.dev/posts/index.xml";
            tags = [
              "Blog"
              "Nix"
            ];
          }
          {
            link = "https://heywoodlh.io/feed.xml";
            tags = [
              "Blog"
              "Nix"
            ];
          }
          {
            link = "https://morss.it/https://signal.org/blog/rss.xml";
            tags = [
              "Blog"
              "Privacy"
            ];
          }
          {
            link = "https://joshblais.com/index.xml";
            tags = [
              "Blog"
              "Emacs"
            ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/kycu";
            name = "Kycu";
            tags = [ "Twitch" ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/slayproxx";
            name = "Slay";
            tags = [ "Twitch" ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/cirno_tv";
            name = "Cirno";
            tags = [ "Twitch" ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/lcolonq";
            name = "lcolonq";
            tags = [ "Twitch" ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/yukievt";
            name = "yukievt";
            tags = [ "Twitch" ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/enlynn_";
            name = "enlynn_";
            tags = [ "Twitch" ];
          }
          {
            link = "https://twitchrss.appspot.com/vod/ppy";
            name = "ppy";
            tags = [ "Twitch" ];
          }
          {
            link = "https://github.com/NixOS/nixpkgs/commits/master.atom";
            name = "nixpkgs";
            tags = [ "Updates" ];
          }
          {
            link = "https://morss.it/https://gazetawroclawska.pl/rss/gazetawroclawska.xml";
            tags = [ "Wrocław" ];
          }
          {
            link = "https://morss.it/https://www.wroclaw.pl/dla-mieszkanca/rss/";
            tags = [ "Wrocław" ];
          }
          {
            link = "https://morss.it/https://www.wroclaw.pl/kultura/rss/";
            tags = [
              "Wrocław"
              "Culture"
            ];
          }
          {
            link = "https://morss.it/https://www.wroclaw.pl/komunikacja/rss/";
            tags = [ "Wrocław" ];
          }
          {
            link = "https://dcf.wroclaw.pl/feed/";
            tags = [
              "Wrocław"
              "Culture"
            ];
          }
          {
            link = "https://konwenty-poludniowe.pl/?format=feed&type=atom";
            tags = [ "Culture" ];
          }
          {
            link = "https://www.internet-czas-dzialac.pl/rss";
            tags = [
              "Tech"
              "Privacy"
            ];
          }
          {
            link = "https://morss.it/https://www.theregister.com/headlines.atom";
            tags = [ "Tech" ];
          }
          {
            link = "https://rachelbythebay.com/w/atom.xml";
            tags = [ "Blog" ];
          }
          {
            link = "https://www.rahuljuliato.com/rss.xml";
            tags = [
              "Blog"
              "Emacs"
              "Tech"
            ];
          }
          {
            link = "https://blog.yaakov.online/feed";
            tags = [
              "Blog"
              "Tech"
            ];
          }
          {
            link = "https://morss.it/https://mitchellh.com/feed.xml";
            tags = [
              "Blog"
              "Programming"
              "Tech"
            ];
          }
        ];
        settings = {
          general = {
            media_player = "mpv";
            entry_save_dir = "~/Documents/";
          };
          queries = [
            {
              name = "Blogs";
              query = "tags:Blog";
            }
            {
              name = "Emacs";
              query = "tags:Emacs";
            }
            {
              name = "YouTube";
              query = "tags:Youtube";
            }
            {
              name = "Odysee";
              query = "tags:Odysee";
            }
            {
              name = "Podcast";
              query = "tags:Podcast";
            }
          ];
          ui = {
            show_borders = false;
            show_read_entries = false;
            show_scrollbar = false;
            entry_max_width = 100;
          };
        };
      };
    };
  };
}
