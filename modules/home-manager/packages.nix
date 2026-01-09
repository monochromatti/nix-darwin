{ inputs, self, ... }:
let
  commonPackages =
    { pkgs, ... }:
    let
      latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
      daily-hours = self.packages.${pkgs.stdenv.hostPlatform.system}.daily-hours;
    in
    {
      home.packages = with pkgs; [
        daily-hours
        # Nix
        nixfmt-rfc-style
        nixpkgs-fmt
        nixd

        # Rust
        rust-analyzer
        cargo

        # Python
        uv
        ty
        ruff

        # Graphics
        d2
        silicon

        # Dev
        gh
        git
        docker
        azure-cli
        qemu

        # Docs
        pandoc
        quarto
        latex

        inputs.fornybar-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

  linuxPackages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Terminal
        ghostty
        xclip

        # UI programs
        spotify
        bitwarden-desktop
        kdePackages.okular
        libreoffice
        keymapp

        # Text editors
        obsidian

        # Graphics
        inkscape
        gimp

        # Docker
        docker-compose

        # NATS
        natscli
        nsc

        # Other
        gpu-screen-recorder
      ];
    };
in
{
  flake.modules.homeManager.packages = commonPackages;

  flake.modules.nixos.packages = {
    home-manager.sharedModules = [ linuxPackages ];
  };
}
