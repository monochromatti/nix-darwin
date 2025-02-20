{
  pkgs,
  upkgs,
  ...
}:
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

      # Dev
      gh
      git

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
      initExtra = ''
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
        "json"
        "ruff"
        "typst"
      ];
      userSettings = {
        assistant = {
          enabled = true;
          version = "2";
          default_model = {
            provider = "zed.dev";
            model = "claude-3-5-sonnet-latest";
          };
        };

        node = {
          path = pkgs.lib.getExe pkgs.nodejs;
          npm_path = pkgs.lib.getExe' pkgs.nodejs "npm";
        };

        hour_format = "hour24";
        auto_update = false;
        terminal = {
          alternate_scroll = "off";
          blinking = "off";
          copy_on_select = false;
          dock = "bottom";
          detect_venv = {
            on = {
              directories = [
                ".env"
                "env"
                ".venv"
                "venv"
              ];
              activate_script = "default";
            };
          };
          env = {
            TERM = "ghostty";
          };
          font_family = "FiraCode Nerd Font";
          font_features = null;
          font_size = null;
          line_height = "comfortable";
          option_as_meta = false;
          button = false;
          shell = "system";
          toolbar = {
            title = true;
          };
          working_directory = "current_project_directory";
        };

        lsp = {
          rust-analyzer = {
            binary = {
              path = pkgs.lib.getExe pkgs.rust-analyzer;
              path_lookup = true;
            };
          };
          nix = {
            binary = {
              path_lookup = true;
            };
          };
          tinymist = {
            binary = {
              path = pkgs.lib.getExe pkgs.tinymist;
              path_lookup = true;
            };
            initialization_options = {
              exportPdf = "onSave";
              outputPath = "$root/$name";
            };
          };
        };

        languages = {
          Python = {
            format_on_save = {
              external = {
                command = "ruff";
                arguments = [
                  "check"
                  "--exit-zero"
                  "--fix"
                  "--stdin-filename"
                  "{buffer_path}"
                  "-"
                ];
              };
            };
            language_servers = [
              "pyright"
              "ruff"
            ];
            formatter = [
              {
                language_server = {
                  name = "ruff";
                };
              }
            ];
          };
          Nix = {
            language_servers = [ "nixd" ];
          };
          Markdown = {
            soft_wrap = "editor_width";
          };
        };

        vim_mode = true;
        load_direnv = "shell_hook";
        base_keymap = "VSCode";
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
      };

    };

    dircolors.enable = true;
    fzf.enable = true;

  };
}
