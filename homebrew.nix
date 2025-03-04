{ inputs, ... }:
{
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
}
