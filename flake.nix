{
  description = "nix-darwin configuration for monochromatti";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs =
    inputs@{ self
    , nixpkgs
    , nix-darwin
    , home-manager
    , nix-homebrew
    , homebrew-cask
    , homebrew-bundle
    , sops-nix
    , ...
    }:
    let
      system = "aarch64-darwin";
      declarativeHome = {
        config = {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        };
      };
      overlayModule = {
        nixpkgs.overlays = [
          inputs.nix-vscode-extensions.overlays.default
          inputs.alacritty-theme.overlays.default
        ];
      };
      homebrewModule = {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          user = "monochromatti";
          taps = {
            "homebrew/homebrew-cask" = homebrew-cask;
            "homebrew/homebrew-bundle" = homebrew-bundle;
          };
          mutableTaps = false;
        };
      };
      users-monochromatti = ./users/monochromatti;
      system-macarius = ./system;

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
            system-macarius

            # Sops
            # sops-nix.nixosModules.sops

            # Home manager
            home-manager.darwinModules.home-manager
            declarativeHome
            users-monochromatti

            # Nix homebrew
            nix-homebrew.darwinModules.nix-homebrew
            homebrewModule

            overlayModule
          ];
        };
      };
    };
}
