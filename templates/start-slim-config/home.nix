{ pkgs, nixpkgs, ... }:

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "ubuntu";
  # home.homeDirectory = "/home/ubuntu";

  home.packages = with pkgs; [
    xorg.xclock
    hello

    # Just enabling it is ok, and might be better
    # nix
    # nixVersions.nix_2_10

    # pciutils # lspci and others
    # coreboot-utils

    # # TODO: testar com o zsh
    ## bashInteractive # https://www.reddit.com/r/NixOS/comments/zx4kmh/alpinewsl_home_manager_bash_issue/
    coreutils
    file
    findutils
    gnugrep
    gnumake
    gnused
    gawk
    hexdump
    which
    xz
    procps
    curl
    lsof
    tree
    killall
    btop
    #    nmap
    #    netcat
    #    nettools
    tmate
    strace
    # ptrace
    #    traceroute
    man
    man-db
    #    (aspellWithDicts (d: with d; [ de en pt_BR ])) # nix repl --expr 'import <nixpkgs> {}' <<<'builtins.attrNames aspellDicts' | tr ' ' '\n'
    #    nix-prefetch-git
    #    nixfmt
    #    hydra-check
    #    nixos-option
    #    shellcheck
    nano
    vim

    # fontconfig
    # fontforge-gtk # TODO: testar fontes usando esse programa
    # pango

    #    nerdfonts
    #    powerline
    #    powerline-fonts


    # (nerdfonts.override { fonts = [ "FiraCode"]; })
    #      (
    #        nerdfonts.override {
    #          fonts = [
    #            "AnonymousPro"
    #            "DroidSansMono"
    #            "FiraCode"
    #            "JetBrainsMono"
    #            "Noto"
    #            "Terminus"
    #            "Hack"
    #            "Ubuntu"
    #            "UbuntuMono"
    #          ];
    #        }
    #      )

    # zsh-nix-shell
    # zsh-powerlevel10k
    # zsh-powerlevel9k
    # zsh-syntax-highlighting

    oh-my-zsh
    # zsh-completions-latest

    # gcc
    # gdb
    # clang
    # rustc
    # python3Full
    # julia-bin

    #    graphviz # dot command comes from here
    jq
    #    unixtools.xxd

    #    gzip
    #    # unrar
    #    unzip
    #    gnutar
    #
    #    btop
    #    htop
    #    asciinema
    git
    openssh
    awscli

    podman

    (
      writeScriptBin "ix" ''
        #! ${pkgs.runtimeShell} -e
          "$@" | "curl" -F 'f:1=<-' ix.io
      ''
    )

    (
      writeScriptBin "erw" ''
        #! ${pkgs.runtimeShell} -e
        echo "$(readlink -f "$(which $1)")"
      ''
    )

    (
      writeScriptBin "frw" ''
        #! ${pkgs.runtimeShell} -e
        file "$(readlink -f "$(which $1)")"
      ''
    )

    (
      writeScriptBin "crw" ''
        #! ${pkgs.runtimeShell} -e
        cat "$(readlink -f "$(which $1)")"
      ''
    )

    (
      writeScriptBin "send-signed-closure-run-time-of-flake-uri-attr-to-bucket" ''
        #! ${pkgs.runtimeShell} -e

           export NIXPKGS_ALLOW_UNFREE=1
           FLAKE_EXPR=$1

           nix build --no-link --print-build-logs "$FLAKE_EXPR"

           nix path-info --impure --recursive "$FLAKE_EXPR" \
           | wc -l

           nix path-info --impure --recursive "$FLAKE_EXPR" \
           | xargs nix store sign --key-file "$HOME"/.nix-sing-cache-keys/cache-priv-key.pem --recursive

           nix path-info --impure --recursive "$FLAKE_EXPR" \
           | xargs -I{} nix \
               copy \
               --max-jobs $(nproc) \
               -vvv \
               --no-check-sigs \
               {} \
               --to 's3://playing-bucket-nix-cache-test'
      ''
    )

    (
      writeScriptBin "send-signed-closure-run-time-of-flake-expression-to-bucket" ''
        #! ${pkgs.runtimeShell} -e

           export NIXPKGS_ALLOW_UNFREE=1
           FLAKE_EXPR=$1

           nix build --no-link --print-build-logs --expr "$FLAKE_EXPR"

           nix path-info --impure --recursive --expr "$FLAKE_EXPR" \
           | wc -l

           nix path-info --impure --recursive --expr "$FLAKE_EXPR" \
           | xargs nix store sign --key-file "$HOME"/.nix-sing-cache-keys/cache-priv-key.pem --recursive

           nix path-info --impure --recursive --expr "$FLAKE_EXPR" \
           | xargs -I{} nix \
               copy \
               --max-jobs $(nproc) \
               -vvv \
               --no-check-sigs \
               {} \
               --to 's3://playing-bucket-nix-cache-test'
      ''
    )

    (
      writeScriptBin "self-send-to-bucket" ''
        #! ${pkgs.runtimeShell} -e
        send-signed-closure-run-time-of-flake-uri-attr-to-bucket \
        ~/.config/nixpkgs#homeConfigurations.'"'"$(id -un)"-"$(hostname)"'"'.activationPackage
      ''
    )

    (
      writeScriptBin "myexternalip" ''
        #! ${pkgs.runtimeShell} -e
        # https://askubuntu.com/questions/95910/command-for-determining-my-public-ip#comment1985064_712144

        curl https://checkip.amazonaws.com
      ''
    )

    (
      writeScriptBin "mynatip" ''
        #! ${pkgs.runtimeShell} -e
           # https://unix.stackexchange.com/a/569306
           # https://serverfault.com/a/256506

           NETWORK_INTERFACE_NAME=$(route | awk '
                   BEGIN           { min = -1 }
                   $1 == "default" {
                                       if (min < 0  ||  $5 < min) {
                                           min   = $5
                                           iface = $8
                                       }
                                   }
                   END             {
                                       if (iface == "") {
                                           print "No \"default\" route found!" > "/dev/stderr"
                                           exit 1
                                       } else {
                                           print iface
                                           exit 0
                                       }
                                   }
                   '
           )

           ip addr show dev $NETWORK_INTERFACE_NAME | grep "inet " | awk '{ print $2 }' | cut -d'/' -f1
      ''
    )

    (
      writeScriptBin "generate-new-ed25519-key-pair" ''
        #! ${pkgs.runtimeShell} -e
        ssh-keygen \
        -t ed25519 \
        -C "$(git config user.email)" \
        -f "$HOME"/.ssh/id_ed25519 \
        -N "" \
        && echo \
        && cat "$HOME"/.ssh/id_ed25519.pub \
        && echo
      ''
    )

    (
      writeScriptBin "try-install-openssh-server" ''
        #! ${pkgs.runtimeShell} -e
          command -v sshd || (command -v apt && sudo apt-get update && sudo apt-get install -y openssh-server)
          command -v sshd || (command -v apk && sudo apk add --no-cache -y openssh-server)
      ''
    )

    (
      writeScriptBin "try-ubuntu-screensaver-lock-disable" ''
        #! ${pkgs.runtimeShell} -e
        # https://linuxhint.com/disable-screen-lock-ubuntu/

        gsettings set org.gnome.desktop.screensaver lock-enabled false
      ''
    )

    (
      writeScriptBin "try-ubuntu-screensaver-lock-enable" ''
        #! ${pkgs.runtimeShell} -e
        gsettings set org.gnome.desktop.screensaver lock-enabled true
      ''
    )

    (
      writeScriptBin "nfm" ''
        #! ${pkgs.runtimeShell} -e
        nix flake metadata $1 --json | jq -r '.url'
      ''
    )

    (
      writeScriptBin "hms" ''
        export NIXPKGS_ALLOW_UNFREE=1; \
        home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
      ''
    )

    (
      writeScriptBin "gphms" ''
        echo $(cd "$HOME/.config/nixpkgs" && git pull) \
        && export NIXPKGS_ALLOW_UNFREE=1; \
        home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
      ''
    )

    (
      writeScriptBin "build-pulling-all-from-cache" ''
        #! ${pkgs.runtimeShell} -e

           set -x

           export NIXPKGS_ALLOW_UNFREE=1

           nix \
           --option eval-cache false \
           --option extra-substituters https://playing-bucket-nix-cache-test.s3.amazonaws.com \
           --option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
           build \
           --impure \
           --keep-failed \
           --max-jobs 0 \
           --no-link \
           --print-build-logs \
           --print-out-paths \
           ~/.config/nixpkgs#homeConfigurations."$(id -un)"-"$(hostname)".activationPackage
      ''
    )

    (
      writeScriptBin "build-and-send-to-cache" ''
        #! ${pkgs.runtimeShell} -e

           set -x

           export NIXPKGS_ALLOW_UNFREE=1

           nix \
           build \
           --impure \
           --keep-failed \
           --no-link \
           --print-build-logs \
           --print-out-paths \
           ~/.config/nixpkgs#homeConfigurations."$(id -un)"-"$(hostname)".activationPackage \
           --post-build-hook e-script-post-build-hook
      ''
    )

    (
      writeScriptBin "gphms-cache" ''
        #! ${pkgs.runtimeShell} -e

        build-pulling-all-from-cache || true

        echo $(cd "$HOME/.config/nixpkgs" && git pull) \
        && export NIXPKGS_ALLOW_UNFREE=1; \
        home-manager switch --impure --flake "$HOME/.config/nixpkgs"#"$(id -un)"-"$(hostname)"
      ''
    )

    (
      writeScriptBin "create-nix-hardcoded-sign-cache-keys" ''

        CACHE_KEYS_FULL_PATH="$HOME"/.nix-sing-cache-keys
        mkdir -m 0700 -pv "$CACHE_KEYS_FULL_PATH"

        cat > "$CACHE_KEYS_FULL_PATH"/cache-pub-key.pem << 'EOF'
        binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg=
        EOF

        cat > "$CACHE_KEYS_FULL_PATH"/cache-priv-key.pem << 'EOF'
        binarycache-1:LS3ApFX0izjIwKCDJFquhuF2+ENxhAv0jdF838AyhUVeI8dL9dP/OIwe7mEahDxnQrzyxrUSqLmQVNjKXfcUmA==
        EOF

        chown -v $USER "$CACHE_KEYS_FULL_PATH"/cache-priv-key.pem \
        && chmod 0600 -v "$CACHE_KEYS_FULL_PATH"/cache-priv-key.pem
      ''
    )

    (
      writeScriptBin "send-signed-closure-run-time-of-flake-uri-attr-to-bucket" ''
        #! ${pkgs.runtimeShell} -e

           export NIXPKGS_ALLOW_UNFREE=1
           FLAKE_EXPR=$1

           nix build --no-link --print-build-logs "$FLAKE_EXPR"

           nix path-info --impure --recursive "$FLAKE_EXPR" \
           | wc -l

           nix path-info --impure --recursive "$FLAKE_EXPR" \
           | xargs nix store sign --key-file "$HOME"/.nix-sing-cache-keys/cache-priv-key.pem --recursive

           nix path-info --impure --recursive "$FLAKE_EXPR" \
           | xargs -I{} nix \
               copy \
               --max-jobs $(nproc) \
               -vvv \
               --no-check-sigs \
               {} \
               --to 's3://playing-bucket-nix-cache-test'
      ''
    )

    (
      writeScriptBin "send-signed-closure-run-time-of-flake-expression-to-bucket" ''
        #! ${pkgs.runtimeShell} -e

           export NIXPKGS_ALLOW_UNFREE=1
           FLAKE_EXPR=$1

           nix build --no-link --print-build-logs --expr "$FLAKE_EXPR"

           nix path-info --impure --recursive --expr "$FLAKE_EXPR" \
           | wc -l

           nix path-info --impure --recursive --expr "$FLAKE_EXPR" \
           | xargs nix store sign --key-file "$HOME"/.nix-sing-cache-keys/cache-priv-key.pem --recursive

           nix path-info --impure --recursive --expr "$FLAKE_EXPR" \
           | xargs -I{} nix \
               copy \
               --max-jobs $(nproc) \
               -vvv \
               --no-check-sigs \
               {} \
               --to 's3://playing-bucket-nix-cache-test'
      ''
    )

    (
      writeScriptBin "nr" ''
        nix repl --expr 'import <nixpkgs> {}'
      ''
    )

    (
      writeScriptBin "script-post-build-hook" ''
        set -euf

        echo "post-build-hook"
        echo "-- ''${OUT_PATHS} --"
        echo "^^ ''${DRV_PATH} ^^"

        # set -x

        KEY_FILE=cache-priv-key.pem
        # Testar ?region=eu-west-1
        CACHE=s3://playing-bucket-nix-cache-test/

        # mapfile -t DERIVATIONS < <(echo "''${OUT_PATHS[@]}" | xargs nix path-info --derivation)
        # mapfile -t DERIVATIONS < <(echo "''${OUT_PATHS[@]}" | xargs nix path-info)
        # mapfile -t DEPENDENCIES < <(echo "''${DRV_PATH[@]}" | xargs nix-store --query --requisites --include-outputs --force-realise)

        # Only runtime for now
        mapfile -t DEPENDENCIES < <(echo "''${OUT_PATHS[@]}" | xargs nix path-info --recursive)

        # TODO: é o correto assinar as derivações, os .drv?
        # echo "''${DERIVATIONS[@]}" | xargs nix store sign --key-file "$KEY_FILE" --recursive

        # TODO:
        echo "''${DEPENDENCIES[@]}" | xargs nix store sign --key-file "$KEY_FILE" --recursive

        # echo "''${DEPENDENCIES[@]}" | xargs nix copy --eval-store auto --no-check-sigs -vvv --to "$CACHE"
        echo "''${DEPENDENCIES[@]}" | xargs nix copy -vvv --to "$CACHE"

      ''
    )

    (
      writeScriptBin "e-script-post-build-hook" ''
        erw script-post-build-hook
      ''
    )
  ];

  # https://github.com/nix-community/home-manager/blob/782cb855b2f23c485011a196c593e2d7e4fce746/modules/targets/generic-linux.nix
  targets.genericLinux.enable = true;

  nix = {
    enable = true;
    # What about github:NixOS/nix#nix-static can it be injected here? What would break?
    # package = pkgs.pkgsStatic.nixVersions.nix_2_10;
    package = pkgs.nixVersions.nix_2_10;
    # Could be useful:
    # export NIX_CONFIG='extra-experimental-features = nix-command flakes'
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    registry.nixpkgs.flake = nixpkgs;

    settings = {
      # use-sandbox = true;
      show-trace = false;
      # system-features = [ "big-parallel" "kvm" "recursive-nix" "nixos-test" ];
      keep-outputs = true;
      keep-derivations = true;

      tarball-ttl = 60 * 60 * 24 * 7 * 4; # = 2419200 = one month
      # readOnlyStore = true;

      # trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
      # trusted-substituters = "fooooo";
    };
  };

  # since we set PAGER to this above, make sure it's installed
  programs.less.enable = true;
  # programs.less.envVariables.PAGER = "foo-bar";

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    # TODO: test it
    # android_sdk.accept_license = true;

    # allowUnfreePredicate = (pkg: true);
  };

  services.systembus-notify.enable = true;
  # services.spotifyd.enable = true;

  fonts = {
    # enableFontDir = true;
    # enableGhostscriptFonts = true;
    # fonts = with pkgs; [
    #   powerline-fonts
    # ];
    fontconfig = {
      enable = true;
      #  defaultFonts = {
      #      monospace = [ "Droid Sans Mono Slashed for Powerline" ];
      #  };
    };
  };

  # TODO: documentar e testar
  home.extraOutputsToInstall = [
    "/share/zsh"
    "/share/bash"
    "/share/fish"
    "/share/fonts" # fc-cache -frv
    # /etc/fonts
  ];

  # https://www.reddit.com/r/NixOS/comments/fenb4u/zsh_with_ohmyzsh_with_powerlevel10k_in_nix/
  programs.zsh = {
    # Your zsh config
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    envExtra = ''
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi
    '';

    # initExtra = "neofetch --ascii_distro NixOS_small --color_blocks off --disable cpu gpu memory term de resolution kernel model";
    # initExtra = "${pkgs.neofetch}/bin/neofetch"; # TODO: checar se esse pacote é seguro

    # promptInit = ''
    #   export POWERLEVEL9K_MODE=nerdfont-complete
    #   source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme
    # '';

    # initExtraBeforeCompInit = ''eval "$(direnv hook zsh)"'';
    autocd = true;


    shellAliases = {
      l = "ls -al";

      #
      nb = "nix build";
      npi = "nix profile install nixpkgs#";
      ns = "nix shell";
      # nr = "nix repl --expr 'import <nixpkgs> {}'";

      rmall = "rm -frv {*,.*}";
    };

    # > closed and reopened the terminal. Then it worked.
    # https://discourse.nixos.org/t/home-manager-doesnt-seem-to-recognize-sessionvariables/8488/8
    sessionVariables = {
      # EDITOR = "nvim";
      # DEFAULT_USER = "foo-bar";
      # ZSH_AUTOSUGGEST_USE_ASYNC="true";
      # ZSH_AUTOSUGGEST_MANUAL_REBIND="true";
      # PROMPT="|%F{153}%n@%m%f|%F{174}%1~%f> ";

      # PAGER = "less";

      LANG = "en_US.utf8";
      # fc-match list
      FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
    };

    historySubstringSearch.enable = true;

    history = {
      save = 50000;
      size = 50000;
      path = "$HOME/.cache/zsh_history";
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      # https://github.com/Xychic/NixOSConfig/blob/76b638086dfcde981292831106a43022588dc670/home/home-manager.nix
      plugins = [
        # "autojump"
        "aws"
        # "cargo"
        "catimg"
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "common-aliases"
        "copyfile"
        "copypath"
        "cp"
        "direnv"
        "docker"
        "docker-compose"
        "emacs"
        "encode64"
        "extract"
        "fancy-ctrl-z"
        "fzf"
        "gcloud"
        "git"
        "git-extras"
        "git-flow-avh"
        "github"
        "gitignore"
        "gradle"
        "history"
        "history-substring-search"
        "kubectl"
        "man"
        "mvn"
        "node"
        "npm"
        "pass"
        "pip"
        "poetry"
        "python"
        "ripgrep"
        "rsync"
        "rust"
        "scala"
        "ssh-agent"
        "sudo"
        "systemadmin" # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemadmin
        "systemd"
        "terraform"
        # "thefuck"
        "tig"
        "timer"
        # "tmux" # It needs tmux to be installed
        "vagrant"
        "vi-mode"
        "vim-interaction"
        "yarn"
        "z"
        "zsh-navigation-tools"
      ];
      theme = "robbyrussell";
      # theme = "bira";
      # theme = "powerlevel10k";
      # theme = "powerlevel9k/powerlevel9k";
      # theme = "agnoster";
      # theme = "gallois";
      # theme = "gentoo";
      # theme = "af-magic";
      # theme = "half-life";
      # theme = "rgm";
      # theme = "crcandy";
      # theme = "fishy";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
        # "$schema" = "https://starship.rs/config-schema.json";
        # add_newline = true;
        command_timeout = 50000; # TODO: qual a unidade?
    };
  };

  # https://nix-community.github.io/home-manager/options.html#opt-programs.direnv.config
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # enableBashIntegration = true;
    # enableFishIntegration = true;
  };

  # This makes it so that if you type the name of a program that
  # isn't installed, it will tell you which package contains it.
  # https://eevie.ro/posts/2022-01-24-how-i-nix.html
  #
  programs.nix-index = {
    enable = true;
    # enableFishIntegration = true;
    # enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.home-manager = {
    enable = true;
  };
}
