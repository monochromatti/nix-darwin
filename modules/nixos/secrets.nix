{ ... }:
{
  flake.modules.nixos.secrets =
    { config, inputs, lib, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        age.keyFile = lib.mkForce "/home/monochromatti/.config/sops/age/keys.txt";
        age.sshKeyPaths = [ ];
        gnupg.sshKeyPaths = [ ];
        defaultSopsFile = ./secrets/secrets.yaml;

        secrets = {
          github-token = { };
          "monochromatti/password".neededForUsers = true;
          "monochromatti/github-token" = { };
          nixbuild-ssh = { };
          databricks-token = { };
        };

        templates."nix-access-tokens" = {
          content = ''
            access-tokens = github.com=${config.sops.placeholder.github-token}
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
