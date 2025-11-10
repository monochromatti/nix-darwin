{
  pkgs,
  upkgs,
  ...
}:
with pkgs.lib;
let
  latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
in
{
  home = {

    username = "monochromatti";
    stateVersion = "24.05";

    packages = with pkgs; [
      # Terminal
      tree
      lazygit
      helix # Text editor
      silicon # Create images of your code
      yazi # File explorer

      # Nix
      nixfmt-rfc-style # Formatter
      nixpkgs-fmt # Formatter
      nixd # Language server

      # Rust
      rust-analyzer
      cargo

      # Python
      uv
      ruff

      # Graphics
      d2

      # Dev
      gh
      git
      docker
      azure-cli
      qemu

      # Docs
      pandoc
      quarto
      latex
    ];
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
          src = pkgs.lib.cleanSource ./dotfiles;
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
        function y() {
           	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
           	yazi "$@" --cwd-file="$tmp"
           	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          		builtin cd -- "$cwd"
           	fi
           	rm -f -- "$tmp"
                }
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
      silent = true;
    };

    zed-editor = {
      enable = true;
      package = upkgs.zed-editor;
      extensions = [
        "nix"
        "toml"
        "mermaid"
        "basher"
        "log"
        "html"
        "sql"
        "just"
        "rainbow-csv"
        "terraform"
        "svelte"
      ];
      userSettings = {
        file_types = {
          "Markdown" = [ "qmd" ];
          "JSON" = [
            "json"
            "avsc"
          ];
        };
        load_direnv = "shell_hook";
        edit_predictions = {
          mode = "subtle";
        };
        vim_mode = true;
        node = {
          path = getExe pkgs.nodejs;
          npm_path = getExe' pkgs.nodejs "npm";
        };
        lsp = {
          ruff = {
            binary = {
              path = getExe pkgs.ruff;
              arguments = [ "server" ];
            };
            formatter.command = [ "ruff format" ];
            initialization_options.settings.configuration = "ruff.toml";
          };
          nixd = {
            binary.path = getExe pkgs.nixd;
            formatter.command = "nixfmt";
          };
          package-version-server = {
            binary.path = "package-version-server";
          };
          ty = {
            binary = {
              path = getExe upkgs.ty;
              arguments = [ "server" ];
            };
          };
        };
        languages = {
          Python = {
            format_on_save = "on";
            code_actions_on_format = {
              "source.fixAll.ruff" = true;
            };
            language_servers = [
              "ruff"
              "ty"
              "!basedpyright"
            ];
          };
          Nix = {
            formatter.external.command = "nixfmt";
            language_servers = [
              "nixd"
              "!nil"
            ];
          };
          Markdown = {
            soft_wrap = "editor_width";
          };
          TOML = {
            tab_size = 2;
          };
        };
      };
    };

    dircolors.enable = true;
    fzf.enable = true;

  };
}
