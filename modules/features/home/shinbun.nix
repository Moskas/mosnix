{
  flake.homeModules.shinbun = { inputs, ... }: {
    config = {
      imports = [ inputs.shinbun.homeManagerModules.default ];
      programs.shinbun = {
        enable = true;
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
