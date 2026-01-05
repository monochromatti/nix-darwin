{ inputs, ... }:
{
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" "macarius";

  flake.modules.darwin.macarius = {
    imports = with inputs.self.modules.darwin; [
      base
      homebrew
      secrets

      monochromatti
    ];

    sops.secrets.github-token = { };

    system.stateVersion = 5;
  };
}
