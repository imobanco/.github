{
  description = "Este é o entrypoint público do Imobanco para desenvolvedores, sim um 'nix flake' :)";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "imobanco-entrypoint";

        pkgsAllowUnfree = import nixpkgs {
          # inherit system;
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };

      in
      rec {

        templates = import ./templates;

        # packages.nixosBuildVMVitualizedx86_64Linux =
        # packages.nixosBuildVMAarch64Linux =

        nixosConfigurations.nixosBuildVMAarch64Linux = let
            pkgs = import nixpkgs {
              # system = "x86_64-linux";
              system = "aarch64-linux";
              config = { allowUnfree = true; };
            };
         in
            nixpkgs.lib.nixosSystem
            {
            system = "aarch64-linux";
            modules = let
                         nixuserKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyhLx5HU63zJJ5Lx4j+NTC/OQZ7Weloc8y+On467kly";
              in [
              "${toString (builtins.getFlake "github:NixOS/nixpkgs/a8f8b7db23ec6450e384da183d270b18c58493d4")}/nixos/modules/virtualisation/build-vm.nix"
              "${toString (builtins.getFlake "github:NixOS/nixpkgs/a8f8b7db23ec6450e384da183d270b18c58493d4")}/nixos/modules/virtualisation/qemu-vm.nix"
              # "${toString (builtins.getFlake "github:NixOS/nixpkgs/a8f8b7db23ec6450e384da183d270b18c58493d4")}/nixos/modules/virtualisation/qemu-guest.nix"
              "${toString (builtins.getFlake "github:NixOS/nixpkgs/a8f8b7db23ec6450e384da183d270b18c58493d4")}/nixos/modules/installer/cd-dvd/channel.nix"

              ({
                boot.kernelParams = [
                  "console=tty0"
                  "console=ttyAMA0,115200n8"
                  # Set sensible kernel parameters
                  # https://nixos.wiki/wiki/Bootloader
                  # https://git.redbrick.dcu.ie/m1cr0man/nix-configs-rb/commit/ddb4d96dacc52357e5eaec5870d9733a1ea63a5a?lang=pt-PT
                  "boot.shell_on_fail"
                  "panic=30"
                  "boot.panic_on_fail" # reboot the machine upon fatal boot issues
                  # TODO: test it
                  "intel_iommu=on"
                  "iommu=pt"

                  # https://discuss.linuxcontainers.org/t/podman-wont-run-containers-in-lxd-cgroup-controller-pids-unavailable/13049/2
                  # https://github.com/NixOS/nixpkgs/issues/73800#issuecomment-729206223
                  # https://github.com/canonical/microk8s/issues/1691#issuecomment-977543458
                  # https://github.com/grahamc/nixos-config/blob/35388280d3b06ada5882d37c5b4f6d3baa43da69/devices/petunia/configuration.nix#L36
                  # cgroup_no_v1=all
                  "swapaccount=0"
                  "systemd.unified_cgroup_hierarchy=0"
                  "group_enable=memory"
                ];

                boot.tmpOnTmpfs = false;
                # https://github.com/AtilaSaraiva/nix-dotfiles/blob/main/lib/modules/configHost/default.nix#L271-L273
                boot.tmpOnTmpfsSize = "100%";

                # https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
                users.extraGroups.nixgroup.gid = 999;

                users.users.nixuser = {
                  isSystemUser = true;
                  password = "";
                  createHome = true;
                  home = "/home/nixuser";
                  homeMode = "0700";
                  description = "The VM tester user";
                  group = "nixgroup";
                  extraGroups = [
                                  "podman"
                                  "kvm"
                                  "libvirtd"
                                  "wheel"
                  ];
                  packages = with pkgs; [
                      direnv
                      file
                      gnumake
                      which
                      coreutils
                  ];
                  shell = pkgs.bashInteractive;
                  uid = 1234;
                  autoSubUidGidRange = true;

                  openssh.authorizedKeys.keyFiles = [
                    "${ pkgs.writeText "nixuser-keys.pub" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyhLx5HU63zJJ5Lx4j+NTC/OQZ7Weloc8y+On467kly" }"
                  ];

                  openssh.authorizedKeys.keys = [
                    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyhLx5HU63zJJ5Lx4j+NTC/OQZ7Weloc8y+On467kly"
                  ];
                };

                  virtualisation = {
                    # following configuration is added only when building VM with build-vm
                    memorySize = 3072; # Use MiB memory.
                    diskSize = 1024 * 16; # Use MiB memory.
                    cores = 6;         # Simulate 6 cores.

                    #
                    docker.enable = false;
                    podman.enable = true;

                    #
                    useNixStoreImage = true;
                    writableStore = true; # TODO
                  };

                  nixpkgs.config.allowUnfree = true;
                  nix = {
                    # package = nixpkgs.pkgs.nix;
                    extraOptions = "experimental-features = nix-command flakes";
                    readOnlyStore = true;
                  };

                  # https://github.com/NixOS/nixpkgs/issues/21332#issuecomment-268730694
                  services.openssh = {
                    allowSFTP = true;
                    kbdInteractiveAuthentication = false;
                    enable = true;
                    forwardX11 = false;
                    passwordAuthentication = false;
                    permitRootLogin = "yes";
                    ports = [ 10022 ];
                    authorizedKeysFiles = [
                      "${ pkgs.writeText "nixuser-keys.pub" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyhLx5HU63zJJ5Lx4j+NTC/OQZ7Weloc8y+On467kly" }"
                    ];
                  };

                time.timeZone = "America/Recife";
                system.stateVersion = "22.11";

                users.users.root = {
                  password = "root";
                  initialPassword = "root";
                  openssh.authorizedKeys.keyFiles = [
                    "${ pkgs.writeText "nixuser-keys.pub" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKyhLx5HU63zJJ5Lx4j+NTC/OQZ7Weloc8y+On467kly" }"
                  ];
                };
              })
            ];
        };

        packages.checkNixFormat = pkgsAllowUnfree.runCommand "check-nix-format" { } ''
          ${pkgsAllowUnfree.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}

          # For fix
          # find . -type f -iname '*.nix' -exec nixpkgs-fmt {} \;

          mkdir $out #sucess
        '';

        apps.${name} = flake-utils.lib.mkApp {
          inherit name;
          drv = packages.${name};
        };

        devShells.default = pkgsAllowUnfree.mkShell {
          buildInputs = with pkgsAllowUnfree; [
            bashInteractive
            coreutils
            curl
            gnumake
            patchelf
            poetry
            python3Full
            tmate
          ];

          shellHook = ''
            echo -e 'IMO \n Banco' | "${pkgsAllowUnfree.figlet}/bin/figlet" | cat
          '';
        };
      });
}
