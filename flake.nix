{
  description = "Nix-darwin configuration for macarius/monochromatti";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nix-darwin
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , homebrew-bundle
    , agenix
    , ...
    }:
    let
      system = "aarch64-darwin";
      unstable = import nixpkgs-unstable { inherit system; };
      users = {
        monochromatti = {
          description = "Mattias Matthiesen";
          home = "/Users/monochromatti";
        };
      };
      declarativeHome = {
        config = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."monochromatti" = ./home.nix;
        };
      };
      overlayModule = {
        nixpkgs.overlays = [
          (final: prev: { uv = unstable.pkgs.uv; }) # Most recent `uv`
        ];
      };
      nixHomebrew = { ... }: {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          user = "monochromatti";
          taps = {
            "homebrew/homebrew-core" = homebrew-core;
            "homebrew/homebrew-cask" = homebrew-cask;
            "homebrew/bundle" = homebrew-bundle;
          };
          mutableTaps = false;
          autoMigrate = true;
        };
      };
    in
    {
      darwinConfigurations = {
        macarius = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs users;
          };
          modules = [
            ./darwin.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            nixHomebrew
            declarativeHome
            overlayModule
          ];
        };
      };
    };
}
