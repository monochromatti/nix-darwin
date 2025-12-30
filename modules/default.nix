{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    ./secrets
    ./hosts/macarius.nix
    ./hosts/firefly.nix
  ];

  systems = [
    "aarch64-darwin"
    "x86_64-linux"
  ];
}
