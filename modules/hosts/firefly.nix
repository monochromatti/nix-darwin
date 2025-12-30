{
  inputs,
  config,
  ...
}:
let
  system = "x86_64-linux";
  upkgs = import inputs.nixpkgs-unstable {
    inherit system;
    overlays = [ inputs.utgard.overlays.ty ];
  };
  modules = config.flake.modules;
  users = {
    monochromatti = {
      description = "Mattias Matthiesen";
      home = "/home/monochromatti";
    };
  };
in
{
  flake.nixosConfigurations.firefly = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs upkgs users;
      inherit (inputs)
        nixos-hardware
        sops-nix
        home-manager
        pc
        utgard
        ;
      self = inputs.self;
    };
    modules = [
      modules.nixos.base

      inputs.pc.nixosModules.hdw-hp-zbook-firefly_g11
      inputs.pc.nixosModules.default
      inputs.pc.nixosModules.docker
      inputs.utgard.nixosModules.aruba-onboard

      modules.nixos.secrets

      inputs.home-manager.nixosModules.home-manager

      (
        {
          config,
          pkgs,
          lib,
          users,
          ...
        }:
        {
          swapDevices = [ { label = "swap"; } ];

          services = {
            xserver.displayManager.gdm.wayland = true;
            utgard.aruba-onboard.enable = true;
          };

          midgard.pc = {
            hostName = "firefly";
            users = {
              monochromatti = {
                fullName = "Mattias Matthiesen";
                email = "mattias.matthiesen@eviny.no";
                git.userName = "monochromatti";
                home-manager.enable = true;
              };
            };
            nixbuild.enable = true;
          };

          hardware = {
            nvidia.package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.production;
            keyboard.zsa.enable = true;
          };

          networking.extraHosts = ''
            127.0.4.1 tor
            127.0.5.1 rp1
            127.0.6.1 brage
          '';

          environment.gnome.excludePackages = with pkgs; [
            gnome-weather
            gnome-music
            gnome-tour
            gnome-photos
          ];

          nixpkgs.overlays = [ inputs.utgard.overlays.aruba-onboard ];

          system.stateVersion = "24.05";
        }
      )

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          extraSpecialArgs = { inherit inputs upkgs; };
          users.monochromatti = {
            imports = [
              modules.homeManager.packages
              modules.homeManager.shell
              modules.homeManager.zed
              modules.homeManager.linux-packages
            ];
            home = {
              username = "monochromatti";
              homeDirectory = users.monochromatti.home;
              stateVersion = "24.05";
              shellAliases = {
                start-vidar-prod = ''
                  az vm start --subscription 584a2d66-5adc-45d5-b796-9d69d54154d6 --resource-group asgard --name vidar
                '';
                start-vidar-dev = ''
                  az vm start --subscription 5111c8c6-28f3-4b11-a07f-0aef3ed4721d --resource-group asgard --name vidar
                '';
                sync-yggdrasil = ''
                  gh repo sync && gh repo sync -b dev-base --force && gh repo sync -b dev --force
                '';
                lg = "lazygit";
                zed = "zeditor .";
              };
            };
            programs.starship = {
              enable = true;
              enableZshIntegration = true;
            };
            xdg.configFile."user-dirs.dirs".source = ../../dotfiles/user-dirs.dirs;
          };
        };
      }
    ];
  };
}
