{
  pkgs,
  users,
  ...
}:
{
  system = {
    primaryUser = "monochromatti";
    stateVersion = 5;
  };

  ids.gids.nixbld = 30000;

  users = { inherit users; };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    mas # Mac App Store CLI
    orbstack
  ];

  nix = {
    enable = true;
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
      "visual-studio-code"
      "coteditor"
      "ghostty"
      "loop"
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
    nerd-fonts.droid-sans-mono
  ];
}
