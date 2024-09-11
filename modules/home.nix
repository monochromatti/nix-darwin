{ pkgs, config, lib, ... }:
let
  latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
  python = pkgs.python312.withPackages (ps: with ps; [ numpy scipy polars ]);
  tex-fmt = pkgs.callPackage
    (pkgs.fetchFromGitHub {
      owner = "wgunderwood";
      repo = "tex-fmt";
      rev = "master";
      sha256 = "sha256-2HUSEK5s7WkBvbLw/u6RxS7fNA4q6iaNfdnyBqc7d68=";
    })
    { };

    vscode-extensions = import ../dotfiles/vscode/extensions.nix { inherit pkgs; };
    vscode-settings = builtins.fromJSON (builtins.readFile ../dotfiles/vscode/settings.json);
in
{
  home = {

    stateVersion = "24.05";

    packages = with pkgs; [

      # Terminal
      tree
      lazygit

      # Database
      postgresql_15

      # Nix dev
      nixfmt-rfc-style # Formatter
      nixpkgs-fmt # Formatter
      nil # Language server

      # Rust
      cargo

      # Python
      python
      ruff
      ruff-lsp
      uv

      # Dev
      gh
      git
      azure-cli

      # Docs
      pandoc
      quarto
      latex
      tex-fmt

      # Utils
      syncthing
      soundsource
    ];
  };

  programs = {

    vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;
      extensions = vscode-extensions;
      userSettings = vscode-settings;
    };

    alacritty = {
      enable = true;
      settings = {
        shell.program = "zsh";
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      plugins = [
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ../dotfiles;
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
