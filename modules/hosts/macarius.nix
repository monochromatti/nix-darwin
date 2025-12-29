{
  inputs,
  config,
  ...
}:
let
  system = "aarch64-darwin";
  upkgs = import inputs.nixpkgs-unstable { inherit system; };
  users = {
    monochromatti = {
      description = "Mattias Matthiesen";
      home = "/Users/monochromatti";
    };
  };
in
{
  flake.darwinConfigurations.macarius = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs upkgs users; };
    modules = with config.flake.modules; [
      darwin.base
      darwin.homebrew
      darwin.secrets
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager
      {
        system = {
          primaryUser = "monochromatti";
          stateVersion = 5;
        };

        users.users.monochromatti = {
          name = "monochromatti";
          home = users.monochromatti.home;
        };

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit upkgs inputs; };
          users.monochromatti = {
            imports = with homeManager; [
              packages
              shell
              zed
            ];
            home = {
              username = "monochromatti";
              stateVersion = "24.05";
            };
          };
        };
      }
    ];
  };
}
