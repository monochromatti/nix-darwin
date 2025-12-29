{ ... }:
{
  flake.modules.darwin.secrets = { config, inputs, users, ... }: {
    imports = [ inputs.sops-nix.darwinModules.sops ];

    sops = {
      age.keyFile = "${users.monochromatti.home}/.config/sops/age/keys.txt";
      age.sshKeyPaths = [];
      gnupg.sshKeyPaths = [];
      defaultSopsFile = ./secrets/secrets.yaml;

      secrets.github-token = { };

      templates."nix-access-tokens" = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder.github-token}
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
}
