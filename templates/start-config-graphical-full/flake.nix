  {
    description = "Home Manager configuration";

    inputs = {
      # Specify the source of Home Manager and Nixpkgs
      home-manager.url = "github:nix-community/home-manager";
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, home-manager, ... }:
      let
        system = "x86_64-linux";
        username = "1M0b4nc0";
      in {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            {
              home = {
                inherit username;
                homeDirectory = "/home/${username}"; # TODO: esse caminho muda no Mac!
                stateVersion = "22.11";
              };
              programs.home-manager.enable = true;
            }
             ./home.nix
          ];

          # TODO: how to: Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bashInteractive
            coreutils
            curl
            gnumake
            patchelf
            poetry
            python3Full
            tmate
          ];
        };
      };
  }
