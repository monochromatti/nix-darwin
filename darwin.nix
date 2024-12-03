{ pkgs, config, users, ... }:
let
  brew = import ./dotfiles/brew.nix;
  main-user = "monochromatti";
in
{
  system = {
    stateVersion = 5;
  };

  users = { inherit users; };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    yabai # Tiling window management
    mas # Mac App Store CLI
  ];

  services = {
    nix-daemon.enable = true;
    yabai = {
      enable = true;
      config = {
        window_placement = "second_child";
        window_border = "on";
        window_border_placement = "inset";
        active_window_border_topmost = "off";
        window_topmost = "off";
        window_shadow = "float";
        active_window_border_color = "0xff5c7e81";
        normal_window_border_color = "0xff505050";
        insert_window_border_color = "0xffd75f5f";
        active_window_opacity = "1.0";
        normal_window_opacity = "0.5";
        split_ratio = "0.50";
        auto_balance = "on";
        layout = "bsp";
        top_padding = 5;
        bottom_padding = 5;
        left_padding = 5;
        right_padding = 5;
        window_gap = 5;
      };
    };
  };

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      auto-optimise-store = false;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "discord"
      "zotero"
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "spotify"
      "obsidian"
      "raycast"
      "iterm2"
      "zoom"
      "vlc"
      "transmission"
      "keka"
      "soundsource"
      "mullvadvpn"
      "docker"
      "visual-studio-code"
    ];
    masApps = {
      "Pixelmator Pro" = 1289583905;
      "Bitwarden" = 1352778147;
    };
  };

  programs = {
    zsh.enable = true;
  };

  fonts.packages = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    noto-fonts
    nerdfonts
  ];
}
