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
    # Rust
    cargo

    # Python
    python312
    uv
    ruff

    # System UI
    yabai

    # Terminal
    iterm2
  ];

  services = {
    nix-daemon.enable = true;

    yabai = {
      enable = true;
      config = {
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
        window_placement = "second_child";
        window_opacity = "off";
        window_opacity_duration = "0.0";
        window_border = "on";
        window_border_placement = "inset";
        window_border_width = 2;
        window_border_radius = 3;
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
        mouse_modifier = "fn";
        mouse_action1 = "move";
        mouse_action2 = "resize";
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
    casks = brew.casks;
    masApps = brew.masApps;
    onActivation.cleanup = "zap";
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


# sudo rm -rf /nix/store/.links
# sudo launchctl stop org.nixos.nix-daemon
# sudo launchctl start org.nixos.nix-daemon
