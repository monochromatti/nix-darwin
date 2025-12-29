{ users, ... }:
{
  imports = [
    ../../modules/darwin/base.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/secrets
  ];

  system = {
    primaryUser = "monochromatti";
    stateVersion = 5;
  };

  users = { inherit users; };
}
