{
  description = "Unified nix-darwin and NixOS configuration";

  nixConfig.flake-registry = "https://raw.githubusercontent.com/fornybar/registry/nixos-25.05/registry.json";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS-specific inputs
    pc = {
      url = "github:fornybar/pc/9dbf61b0e32a49c09c244bb03cc2163b23007b4d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    utgard = {
      url = "github:fornybar/utgard";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fornybar-ai-tools = {
      url = "github:fornybar/fornybar-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
