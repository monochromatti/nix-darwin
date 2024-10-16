{ pkgs, config, lib, ... }:
let
  latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
  python = pkgs.python312.withPackages (ps: with ps; [ numpy scipy polars ]);
  vscode-extensions = import ./dotfiles/vscode/extensions.nix { inherit pkgs; };
  vscode-settings = builtins.fromJSON (builtins.readFile ./dotfiles/vscode/settings.json);
in
{
  home = {

    username = "monochromatti";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Terminal
      tree
      lazygit

      # Nix dev
      nixfmt-rfc-style # Formatter
      nixpkgs-fmt # Formatter
      nil # Language server

      # Dev
      gh
      git
      azure-cli

      # Docs
      pandoc
      quarto
      latex

      # Utils
      age
      syncthing
      soundsource
      keka

      # Media
      vlc-bin
      transmission_4

      # Comms
      zoom-us
    ];
  };

  programs = {

    home-manager.enable = true;

    vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;
      extensions = vscode-extensions;
      userSettings = vscode-settings;
    };

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
