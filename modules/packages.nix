{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        daily-hours = pkgs.callPackage ../packages/daily-hours { };
      };
    };
}
