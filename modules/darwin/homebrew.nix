{ ... }:
{
  flake.modules.darwin.homebrew = { inputs, ... }: {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "monochromatti";
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/bundle" = inputs.homebrew-bundle;
      };
      mutableTaps = false;
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
      taps = [ "homebrew/cask" ];
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
  };
}
