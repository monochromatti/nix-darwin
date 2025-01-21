{
  description = "Nix-darwin configuration for macarius/monochromatti";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
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
    agenix = {
      url = "github:ryantm/agenix";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      agenix,
      ...
    }:
    let
      system = "aarch64-darwin";
      users = {
        monochromatti = {
          description = "Mattias Matthiesen";
          home = "/Users/monochromatti";
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
            ./homebrew.nix
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."monochromatti" = import ./home.nix;
            }
          ];
        };
      };
    };
}
