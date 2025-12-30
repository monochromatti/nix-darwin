{ ... }:
{
  flake.modules.darwin.homebrew = {
    homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
      taps = [ "homebrew/cask" ];
      brews = [ "tw93/tap/mole" ];
      casks = [
        "discord"
        "zotero"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "spotify"
        "obsidian"
        "raycast"
        "zoom"
        "vlc"
        "transmission"
        "keka"
        "soundsource"
        "visual-studio-code"
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
