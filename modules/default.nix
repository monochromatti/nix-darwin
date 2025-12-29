{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./hosts/macarius.nix
  ];

  systems = [ "aarch64-darwin" ];
}
