{ pkgs, config, lib, ... }:
let
  latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
  python = pkgs.python312.withPackages (ps: with ps; [ numpy scipy polars ]);
in
{
  home = {

    username = "monochromatti";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Terminal
      tree
      lazygit
      helix

      # Nix dev
      nixfmt-rfc-style # Formatter
      nixpkgs-fmt # Formatter
      nil # Language server

      # Dev
      gh
      git
      uv
      azure-cli
      docker

      # Docs
      pandoc
      quarto
      latex

      # Utils
      age
    ];
  };

  services = {
    syncthing = {
      enable = true;
    };
  };

  programs = {

    home-manager.enable = true;

    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./dotfiles;
          file = "p10k.zsh";
        }
      ];
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
      envExtra = ''
        zstyle ':autocomplete:*' list-lines 5
      '';
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    dircolors.enable = true;
    fzf.enable = true;

  };
}
