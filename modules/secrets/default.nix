{ inputs, ... }:
let
  secretsFile = ./secrets.yaml;
  nixAccessTokensPath = "/etc/nix/access-tokens.conf";
  users = inputs.self.lib.users;

  secretsModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    let
      userHome =
        if pkgs.stdenv.isDarwin then users.monochromatti.home.darwin else users.monochromatti.home.linux;
    in
    {
      config = {
        home-manager.sharedModules = [
          { home.packages = [ pkgs.sops ]; }
        ];

        sops = {
          age.keyFile = mkForce "${userHome}/.config/sops/age/keys.txt";
          age.sshKeyPaths = [ ];
          gnupg.sshKeyPaths = [ ];
          defaultSopsFile = mkForce secretsFile;

          templates."nix-access-tokens" = {
            content = ''
              access-tokens = github.com=${config.sops.placeholder."monochromatti/github-token"}
            '';
            path = nixAccessTokensPath;
            owner = "root";
            group = if pkgs.stdenv.isDarwin then "staff" else "root";
            mode = "0640";
          };
        };
        nix.extraOptions = ''
          !include ${nixAccessTokensPath}
        '';
      };
    };
in
{
  flake.modules.darwin.secrets = secretsModule;
  flake.modules.nixos.secrets = secretsModule;
}
