{ ... }:
{
  imports = [
    ../../modules/home-manager/packages.nix
    ../../modules/home-manager/shell.nix
    ../../modules/home-manager/zed.nix
  ];

  home = {
    username = "monochromatti";
    stateVersion = "24.05";
  };
}
