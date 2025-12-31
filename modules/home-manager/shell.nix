{ ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        tree
        lazygit
        yazi
      ];

      programs = {
        home-manager.enable = true;

        starship = {
          enable = true;
          enableZshIntegration = true;
        };

        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
          silent = true;
        };

        dircolors.enable = true;
        fzf.enable = true;

        zsh = {
          enable = true;
          autocd = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          plugins = [
            {
              name = "powerlevel10k-config";
              src = pkgs.lib.cleanSource ../../dotfiles;
              file = "p10k.zsh";
            }
          ];
          zplug = {
            enable = true;
            plugins = [
              { name = "zsh-users/zsh-autosuggestions"; }
              {
                name = "romkatv/powerlevel10k";
                tags = [
                  "as:theme"
                  "depth:1"
                ];
              }
            ];
          };
          envExtra = ''
            zstyle ':autocomplete:*' list-lines 5
          '';
          initContent = ''
            source ${../../dotfiles/init.zsh}
          '';
        };
      };
    };
}
