{
  description = "Home Manager configuration";

  inputs = {
    /*
    Specify the source of Home Manager and Nixpkgs
    nix flake metadata github:nix-community/home-manager/release-22.11

    nix flake update \
    --override-input home-manager github:nix-community/home-manager/$(nix eval --impure --raw --expr '(builtins.getFlake "github:nix-community/home-manager/release-23.05").rev') \
    --override-input nixpkgs github:NixOS/nixpkgs/$(nix eval --impure --raw --expr '(builtins.getFlake "github:NixOS/nixpkgs/release-23.05").rev')

    # https://channels.nix.gsc.io/nixos-22.11/history
    # https://github.com/NixOS/nix/issues/3779#issuecomment-653598626
    nix flake lock \
    --override-input nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b \
    --override-input home-manager github:nix-community/home-manager/b372d7f8d5518aaba8a4058a453957460481afbc

    nix flake lock \
    --override-input nixpkgs github:NixOS/nixpkgs/$(nix eval --impure --raw --expr '(builtins.getFlake "github:NixOS/nixpkgs/release-23.05").rev') \
    --override-input home-manager github:nix-community/home-manager/$(nix eval --impure --raw --expr '(builtins.getFlake "github:nix-community/home-manager/release-23.05").rev')

    */
    home-manager.url = "github:nix-community/home-manager";

    nixpkgs.url = "github:nixos/nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "1M0b4nc0";
      hostname = "fooo";

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."${username}-${hostname}" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          # https://discourse.nixos.org/t/flakes-error-error-attribute-outpath-missing/18044/2
          # ({...}: { nix.registry.nixpkgs.flake = nixpkgs; })
          {
            home = {
              inherit username;
              homeDirectory = "/home/${username}"; # TODO: esse caminho muda no Mac!
              stateVersion = "22.11";
              # https://discourse.nixos.org/t/correct-way-to-use-nixpkgs-in-nix-shell-on-flake-based-system-without-channels/19360/3
              # sessionVariables.NIX_PATH = "nixpkgs=nixpkgs=flake:?";
              sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs.outPath}";
              enableNixpkgsReleaseCheck = true;
            };
            programs.home-manager.enable = true;
          }
          ./home.nix
        ];

        # TODO: how to: Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { nixpkgs = nixpkgs; };
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
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
