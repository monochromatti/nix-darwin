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

      # Utils
      age
      syncthing
      soundsource
    ];
  };

  programs = {

    home-manager.enable = true;

    ssh = {
      knownHosts = {
        nixbuild = {
          hostNames = [ "eu.nixbuild.net" ];
          publicKey = builtins.readFile "${config.home.homeDirectory}/.config/nix-secrets/keys/nixbuild-key.pub";
        };
      };
      extraConfig = ''
        Host eu.nixbuild.net
          PubkeyAcceptedKeyTypes ssh-ed25519
          ServerAliveInterval 60
          IPQoS throughput
          IdentityFile ${config.home.homeDirectory}/.config/nix-secrets/keys
      '';
    };

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
        import = [ pkgs.alacritty-theme.afterglow ];
        shell.program = "zsh";
        window = {
          decorations = "Transparent";
          blur = true;
          padding = { x = 20; y = 40; };
        };
        font = {
          normal = { family = "FiraCode Nerd Font"; };
          size = 14;
        };
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

  # local = {
  #   dock.enable = true;
  #   dock.entries = [
  #     { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #     { path = "/System/Applications/Home.app/"; }
  #   ];
  # };




}
