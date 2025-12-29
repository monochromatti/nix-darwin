{ pkgs, ... }:
let
  latex = pkgs.texliveMedium.withPackages (ps: with ps; [ arara ]);
in
{
  home.packages = with pkgs; [
    # Terminal
    tree
    lazygit
    helix
    silicon
    yazi

    # Secrets
    sops

    # Nix
    nixfmt-rfc-style
    nixpkgs-fmt
    nixd

    # Rust
    rust-analyzer
    cargo

    # Python
    uv
    ruff

    # Graphics
    d2

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
  ];
}
