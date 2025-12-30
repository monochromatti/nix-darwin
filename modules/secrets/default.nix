{ ... }:
let
  secretsFile = ./secrets.yaml;
in
{
  flake.modules.darwin.secrets =
    {
      config,
      inputs,
      users,
      ...
    }:
    {
      imports = [ inputs.sops-nix.darwinModules.sops ];

      sops = {
        age.keyFile = "${users.monochromatti.home}/.config/sops/age/keys.txt";
        age.sshKeyPaths = [ ];
        gnupg.sshKeyPaths = [ ];
        defaultSopsFile = secretsFile;

        secrets."monochromatti/github-token" = { };

        templates."nix-access-tokens" = {
          content = ''
            access-tokens = github.com=${config.sops.placeholder."monochromatti/github-token"}
          '';
          path = "/etc/nix/access-tokens.conf";
          owner = "root";
          group = "staff";
          mode = "0640";
        };
      };

      nix.extraOptions = ''
        !include /etc/nix/access-tokens.conf
      '';
    };

  flake.modules.nixos.secrets =
    {
      config,
      inputs,
      lib,
      users,
      ...
    }:
    with lib;
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        age.keyFile = mkForce "${users.monochromatti.home}/.config/sops/age/keys.txt";
        age.sshKeyPaths = [ ];
        gnupg.sshKeyPaths = [ ];
        defaultSopsFile = mkForce secretsFile;

        secrets = {
          "monochromatti/password" = {
            sopsFile = mkForce secretsFile;
            neededForUsers = true;
          };
          "monochromatti/github-token".sopsFile = mkForce secretsFile;
          nixbuild-ssh.sopsFile = mkForce secretsFile;
        };

        templates."nix-access-tokens" = {
          content = ''
            access-tokens = github.com=${config.sops.placeholder."monochromatti/github-token"}
          '';
          path = "/etc/nix/access-tokens.conf";
          owner = "root";
          group = "root";
          mode = "0640";
        };
      };

      nix.extraOptions = ''
        !include /etc/nix/access-tokens.conf
      '';
    };
}
