{ pkgs }:
let
  marketplace-extensions = with (pkgs.forVSCodeVersion pkgs.vscode.version).vscode-marketplace; [
    mkhl.direnv
    tamasfe.even-better-toml
    yzhang.markdown-all-in-one
    wendell.atom-one-dark-theme-underlined
    ms-toolsai.jupyter
    jnoortheen.nix-ide
    ms-python.python
    charliermarsh.ruff
    rust-lang.rust-analyzer
    james-yu.latex-workshop
    tecosaur.latex-utilities
  ];
  vscode-extensions = with pkgs.vscode-extensions; [
    github.copilot
    github.copilot-chat
  ];
in
marketplace-extensions ++ vscode-extensions

