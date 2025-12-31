{ inputs, ... }:
{
  flake.lib = {
    users = {
      monochromatti = {
        description = "Mattias Matthiesen";
        home = {
          darwin = "/Users/monochromatti";
          linux = "/home/monochromatti";
        };
      };
    };

    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit (inputs)
            nixos-hardware
            sops-nix
            home-manager
            self
            ;
        };
        modules = [
          inputs.self.modules.nixos.${name}
          { nixpkgs.hostPlatform = system; }
        ];
      };
    };

    mkDarwin = system: name: {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.self.modules.darwin.${name}
          { nixpkgs.hostPlatform = system; }
        ];
      };
    };
  };
}
