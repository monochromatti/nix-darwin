{ ... }:
{
  flake.modules.homeManager.linux-packages =
    { pkgs, inputs, ... }:
    {
      home.packages =
        (with pkgs; [
          # Terminal
          xclip

          # UI programs
          spotify
          bitwarden
          kdePackages.okular
          libreoffice
          keymapp

          # Text editors
          obsidian
          package-version-server

          # Graphics
          inkscape
          gimp

          # Docker
          docker
          docker-compose

          # NATS
          natscli
          nsc

          # Other
          gpu-screen-recorder
        ])
        ++ [
          inputs.fornybar-ai-tools.packages.${pkgs.system}.default
        ];
    };
}
