{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
    # nix flake metadata github:nix-community/home-manager/release-22.11
    home-manager.url = "github:nix-community/home-manager/b372d7f8d5518aaba8a4058a453957460481afbc";

    # nix flake metadata github:nixos/nixpkgs/release-22.11
    nixpkgs.url = "github:nixos/nixpkgs/0938d73bb143f4ae037143572f11f4338c7b2d1c";
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
