{
  pkgs,
  config,
  lib,
  ...
}:
let
  latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
  python = pkgs.python312.withPackages (
    ps: with ps; [
      numpy
      scipy
      polars
    ]
  );
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

      # Rust dev
      rust-analyzer
      cargo

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

    zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "json"
      ];

      ## everything inside of these brackets are Zed options.
      userSettings = {

        assistant = {
          enabled = true;
          version = "2";
          default_open_ai_model = null;
          default_model = {
            provider = "zed.dev";
            model = "claude-3-5-sonnet-latest";
          };
        };

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
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
              path = lib.getExe pkgs.rust-analyzer;
              path_lookup = true;
            };
          };
          nix = {
            binary = {
              path_lookup = true;
            };
          };
        };

        # languages = {
        #   python = {
        #     formatter = {
        #       provider = "ruff";
        #       binary = {
        #         path = lib.getExe python;
        #         path_lookup = true;
        #       };
        #     };
        #     linter = {
        #       provider = "ruff";
        #       binary = {
        #         path = lib.getExe python;
        #         path_lookup = true;
        #       };
        #     };
        #   };
        # };

        vim_mode = true;
        load_direnv = "shell_hook";
        base_keymap = "VSCode";
        theme = {
          mode = "system";
          light = "One Light";
          dark = "One Dark";
        };
        show_whitespaces = "all";
        # ui_font_size = 16;
        # buffer_font_size = 16;
      };

    };

    dircolors.enable = true;
    fzf.enable = true;

  };
}
