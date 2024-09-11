{ inputs, pkgs, lib, ... }:

{
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    cargo
    python3
    uv
  ];

  services = {
    nix-daemon.enable = true;

      # syncthing = {
      #   enable = true;
      #   user = "monochromatti";
      #   dataDir = "/Users/monochromatti/thought_lake";
      #   configDir = "/Users/monochromatti/.config/syncthing";
      #   overrideDevices = true;
      #   overrideFolders = true;
      #   settings = {
      #     devices = {
      #       "device1" = { id = "DEVICE-ID-GOES-HERE"; };
      #       "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      #     };
      #     folders = {
      #       "Documents" = {
      #         # Name of folder in Syncthing, also the folder ID
      #         path = "/home/myusername/Documents"; # Which folder to add to Syncthing
      #         devices = [ "device1" "device2" ]; # Which devices to share the folder with
      #       };
      #       "Example" = {
      #         path = "/home/myusername/Example";
      #         devices = [ "device1" ];
      #         ignorePerms = false; # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
      #       };
      #     };
      #   };
      # };
  };

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  programs = {
    zsh.enable = true;
  };

  users.users.monochromatti.home = "/Users/monochromatti";

  homebrew = {
    enable = true;
    casks = import ../dotfiles/casks;
  };
}
