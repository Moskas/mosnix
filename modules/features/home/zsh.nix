{
  flake.homeModules.zsh =
    { config, pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        shellAliases = {
          e = "$EDITOR"; # e = edit
          b = "ranger"; # b = browse
          cat = "bat --decorations=never --paging=never --theme=ansi";
          ccat = "bat --decorations=never --paging=never --color=never";
          tx = "tmux new -As0";
          lld = "ll --no-permissions --no-user --no-time --no-git --no-filesize --tree -D";
          duf = "duf -theme ansi";
          mg = "emacs -nw --eval '(magit)'";
          lg = "lazygit";
        };
        history = {
          size = 10000;
          path = "${config.xdg.dataHome}/zsh/history";
          ignoreDups = true;
        };
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        autocd = false;
        defaultKeymap = "emacs";
        plugins = [ ];
        initContent = ''
          source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
          export PATH=~/.config/emacs/bin:$PATH # Doom Emacs helper bin
          export PATH=~/.local/share/applications/:$PATH # Kinda redundant but eh
          export PATH=~/.cargo/bin/:$PATH # For rare occasion that I might need a Rust app from cargo

          # Fix emacs colors for ssh
          if [ -n $SSH_CLIENT ]; then
             export COLORTERM="truecolor"
          fi

          if [[ "$(hostname)" == "shimakaze" ]]; then
             alias emacs="emacs -nw"
          fi

          # Legend
          # '^' = CTRL, '^[' = ESC
          bindkey '^p' history-search-backward
          bindkey '^n' history-search-forward
          bindkey '^[w' kill-region
          bindkey '^[\[1;5C' forward-word
          bindkey '^[\[1;5D' backward-word
        '';
      };

    };
}
