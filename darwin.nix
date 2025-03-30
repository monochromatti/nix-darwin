{
  pkgs,
  users,
  ...
}:
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
    mas # Mac App Store CLI
  ];

  services = {
    nix-daemon.enable = true;
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
      "coteditor"
      "ghostty"
      "loop"
      "orbstack"
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
