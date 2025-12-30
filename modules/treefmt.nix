{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { system, ... }:
    {
      treefmt = {
        pkgs = import inputs.nixpkgs { inherit system; };
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
    };
}
