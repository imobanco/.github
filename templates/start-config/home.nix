{ pkgs, ... }:

{

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  # home.username = "ubuntu";
  # home.homeDirectory = "/home/ubuntu";

  home.packages = with pkgs; [
    # Graphical packages
    #anydesk
    #blender
    #brave
    #dbeaver
    #discord
    #gimp
    #gitkraken
    #google-chrome
    #inkscape
    #insomnia
    #jetbrains.pycharm-community
    #keepassxc
    #kolourpaint
    #libreoffice
    #obsidian
    #okular
    #peek
    #postman
    #qbittorrent
    #spotify
    #tdesktop
    #virt-manager
    #vlc
    #vscodium

    xorg.xclock

    # sudo $(which lshw) -C display
    # sudo dmesg | grep drm
    # glxgears -info
    # lspci | grep -i vga
    # mesa
    # mesa-demos
    # libglvnd # find / -name 'libGL.so' 2>/dev/null
    # vulkan-loader
    # vulkan-headers
    # mesa_drivers
    # linuxPackages.nvidia_x11
    # cudatoolkit
    # cudatoolkit.lib
    # mpi

    #
    steam-run

    xorg.xclock
    hello
    sl
    asciiquarium
    figlet
    cowsay
    ponysay
    cmatrix

    # Just enabling it is ok, and might be better
    # nix
    # nixVersions.nix_2_10

    # pciutils # lspci and others
    # coreboot-utils

    # # TODO: testar com o zsh
    ## bashInteractive # https://www.reddit.com/r/NixOS/comments/zx4kmh/alpinewsl_home_manager_bash_issue/
    coreutils
    binutils
    utillinux
    xorg.xkill
    glibc.bin
    patchelf
    gparted
    # glxinfo
    file
    findutils
    gnugrep
    gnumake
    gnused
    gawk
    hexdump
    which
    xz
    exfat
    procps
    curl
    wget
    lsof
    tree
    ripgrep
    killall
    nmap
    netcat
    nettools
    tmate
    strace
    # ptrace
    traceroute
    man
    man-db
    (aspellWithDicts (d: with d; [ de en pt_BR ])) # nix repl --expr 'import <nixpkgs> {}' <<<'builtins.attrNames aspellDicts' | tr ' ' '\n'
    gnome.simple-scan
    imagemagick
    nix-prefetch-git
    nixfmt
    hydra-check
    nixos-option
    shellcheck

    fontconfig
    # fontforge-gtk # TODO: testar fontes usando esse programa
    # pango

    # arphic-ukai
    # arphic-uming
    # aurulent-sans
    # comic-relief
    # corefonts           # Microsoft free fonts
    # dejavu_fonts
    # dina-font
    # fira                # Monospace
    # fira-code
    # fira-code-symbols
    # font-awesome # font-awesome-ttf, font-awesome_4
    # freefont_ttf
    # hack-font
    # hasklig
    # inconsolata         # Monospace
    # ionicons
    # lato
    # liberation_ttf
    # lineicons
    # montserrat
    # mplus-outline-fonts
    # nerdfonts # Really big, but only this font fixed some issues with starship
    # noto-fonts
    # noto-fonts-emoji
    # noto-fonts-extra
    powerline
    powerline-fonts
    # source-han-sans-japanese
    # source-han-sans-korean
    # source-han-sans-simplified-chinese
    # source-han-sans-traditional-chinese
    # source-sans
    # source-sans-pro
    # sudo-font
    # symbola
    # twemoji-color-font
    # ubuntu_font_family
    # unifont             # International languages
    # wqy_microhei
    # wqy_zenhei
    # xkcd-font

    # (nerdfonts.override { fonts = [ "FiraCode"]; })
    (
      nerdfonts.override {
        fonts = [
          #  "3270"
          #  "Agave"
          #  "AnonymousPro"
          #  "Arimo"
          #  "AurulentSansMono"
          #  "BigBlueTerminal"
          #  "BitstreamVeraSansMono"
          #  "CascadiaCode"
          #  "CodeNewRoman"
          #  "Cousine"
          #  "DaddyTimeMono"
          #  "DejaVuSansMono"
          #  "DroidSansMono"
          #  "FantasqueSansMono"
          "FiraCode"
          #  "FiraMono"
          #  "FontPatcher"
          #  "Go-Mono"
          #  "Gohu"
          #  "Hack"
          #  "Hasklig"
          #  "HeavyData"
          #  "Hermit"
          #  "iA-Writer"
          #  "IBMPlexMono"
          #  "Inconsolata"
          #  "InconsolataGo"
          #  "InconsolataLGC"
          #  "Iosevka"
          "JetBrainsMono"
          #  "Lekton"
          #  "LiberationMono"
          #  "Lilex"
          #  "Meslo"
          #  "Monofur"
          #  "Monoid"
          #  "Mononoki"
          #  "MPlus"
          #  "NerdFontsSymbolsOnly"
          #  "Noto"
          #  "OpenDyslexic"
          #  "Overpass"
          #  "ProFont"
          #  "ProggyClean"
          #  "RobotoMono"
          #  "ShareTechMono"
          #  "SourceCodePro"
          #  "SpaceMono"
          #  "Terminus"
          #  "Tinos"
          "Ubuntu"
          #  "UbuntuMono"
          #  "VictorMono"
        ];
      }
    )

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

    graphviz # dot command comes from here
    jq
    unixtools.xxd

    gzip
    # unrar
    unzip
    gnutar

    btop
    htop
    asciinema
    git
    openssh
    # sshfs # TODO: testar

    podman
    # runc
    # skopeo
    # conmon
    # slirp4netns
    # shadow

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
      writeScriptBin "crw" ''
        #! ${pkgs.runtimeShell} -e
        cat "$(readlink -f "$(which $1)")"
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


        while $(echo 'yes' | ssh -T -o ConnectTimeout=1 git@github.com &>/dev/null); do echo $(date +'%d/%m/%Y %H:%M:%S:%3N') && sleep 0.5; done

        ssh -T -o ConnectTimeout=1 git@github.com &>/dev/null
        test $? -eq 1 || echo "Error in ssh -T -o ConnectTimeout=1 git@github.com

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

      DIRECTORY_TO_CLONE=/home/"$USER"/.config/nixpkgs


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
      trusted-public-keys = binarycache-1:tcdI+LZIBrh5xmvW2P0NO5ZPwTKpkCoGq3Hmmj58yOI=
      substituters = https://playing-bucket-nix-cache-test.s3.amazonaws.com
    '';

    settings = {
      # use-sandbox = true;
      show-trace = true;
      # system-features = [ "big-parallel" "kvm" "recursive-nix" "nixos-test" ];
      keep-outputs = true;
      keep-derivations = true;

      tarball-ttl = 60 * 60 * 24 * 7 * 4; # = 2419200 = one month
      # readOnlyStore = true;

      # trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
      # trusted-substituters = "fooooo";
    };
  };

  nixpkgs.config = {
    allowBroken = false;
    allowUnfree = true;
    # TODO: test it
    # android_sdk.accept_license = true;
  };

  services.systembus-notify.enable = true;
  services.spotifyd.enable = true;

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

  programs.bash = {
    enable = false;
    # bashrcExtra = "echo foo-bar";
    sessionVariables = {
      A_B_C = "a-b-c";
      FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts/";
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
    initExtra = "${pkgs.neofetch}/bin/neofetch"; # TODO: checar se esse pacote é seguro

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

  #  programs.starship = {
  #    enable = true;
  #    enableZshIntegration = true;
  #  };

  # Credits:
  # https://gist.github.com/s-a-c/0e44dc7766922308924812d4c019b109
  # https://gist.github.com/search?q=So+either+put+%22Important+Documents%22+before+%22Documents%22+or+use+the+substituted+version%3A%3B&ref=searchresults
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;
      command_timeout = 500;
      continuation_prompt = "[∙](bright-black) ";
      # format = "[](0x9A348E)$username$hostname$localip$shlvl$singularity$kubernetes[](fg:0x9A348E bg:0xDA627D)$directory$vcsh[](fg:0xDA627D bg:0xFCA17D)$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch[](fg:0x86BBD8 bg:0x06969A)$docker_context$package$buf[](fg:0xFCA17D bg:0x86BBD8)$c$cmake$cobol$container$daml$dart$deno$dotnet$elixir$elm$erlang$golang$haskell$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$perl$php$pulumi$purescript$python$rlang$red$ruby$rust$scala$swift$terraform$vlang$vagrant$zig$nix_shell$conda$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery[](fg:0x06969A bg:0x33658A)$time$status$shell$character";
      right_format = "";
      scan_timeout = 30;
      aws = {
        format = "[$symbol($profile )(($region) )([$duration] )]($style)";
        symbol = "🅰 ";
        style = "bold yellow";
        disabled = false;
        expiration_symbol = "X";
        force_display = false;
      };
      aws.region_aliases = { };
      aws.profile_aliases = { };
      azure = {
        format = "[$symbol($subscription)([$duration])]($style) ";
        symbol = "ﴃ ";
        style = "blue bold";
        disabled = true;
      };
      battery = {
        format = "[$symbol$percentage]($style) ";
        charging_symbol = " ";
        discharging_symbol = " ";
        empty_symbol = " ";
        full_symbol = " ";
        unknown_symbol = " ";
        disabled = false;
        display = [
          {
            style = "red bold";
            threshold = 10;
          }
        ];
      };
      buf = {
        format = "[$symbol ($version)]($style)";
        version_format = "v$raw";
        symbol = "";
        style = "bold blue";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "buf.yaml"
          "buf.gen.yaml"
          "buf.work.yaml"
        ];
        detect_folders = [ ];
      };
      c = {
        format = "[$symbol($version(-$name) )]($style)";
        version_format = "v$raw";
        style = "fg:149 bold bg:0x86BBD8";
        symbol = " ";
        disabled = false;
        detect_extensions = [
          "c"
          "h"
        ];
        detect_files = [ ];
        detect_folders = [ ];
        #          commands = [
        #            [
        #            "cc"
        #            "--version"
        #            ]
        #            [
        #            "gcc"
        #            "--version"
        #            ]
        #            [
        #            "clang"
        #            "--version"
        #            ]
        #          ];
      };
      character = {
        format = "$symbol ";
        vicmd_symbol = "[❮](bold green)";
        disabled = false;
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      cmake = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "△ ";
        style = "bold blue";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "CMakeLists.txt"
          "CMakeCache.txt"
        ];
        detect_folders = [ ];
      };
      cmd_duration = {
        min_time = 2000;
        format = "⏱ [$duration]($style) ";
        style = "yellow bold";
        show_milliseconds = false;
        disabled = false;
        show_notifications = false;
        min_time_to_notify = 45000;
      };
      cobol = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "⚙️ ";
        style = "bold blue";
        disabled = false;
        detect_extensions = [
          "cbl"
          "cob"
          "CBL"
          "COB"
        ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      conda = {
        truncation_length = 1;
        format = "[$symbol$environment]($style) ";
        symbol = " ";
        style = "green bold";
        ignore_base = true;
        disabled = false;
      };
      container = {
        format = "[$symbol [$name]]($style) ";
        symbol = "⬢";
        style = "red bold dimmed";
        disabled = false;
      };
      crystal = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🔮 ";
        style = "bold red";
        disabled = false;
        detect_extensions = [ "cr" ];
        detect_files = [ "shard.yml" ];
        detect_folders = [ ];
      };
      dart = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🎯 ";
        style = "bold blue";
        disabled = false;
        detect_extensions = [ "dart" ];
        detect_files = [
          "pubspec.yaml"
          "pubspec.yml"
          "pubspec.lock"
        ];
        detect_folders = [ ".dart_tool" ];
      };
      deno = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🦕 ";
        style = "green bold";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "deno.json"
          "deno.jsonc"
          "mod.ts"
          "deps.ts"
          "mod.js"
          "deps.js"
        ];
        detect_folders = [ ];
      };
      directory = {
        disabled = false;
        fish_style_pwd_dir_length = 0;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        home_symbol = "~";
        read_only = " ";
        read_only_style = "red";
        repo_root_format = "[$before_root_path]($style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        style = "cyan bold bg:0xDA627D";
        truncate_to_repo = true;
        truncation_length = 3;
        truncation_symbol = "…/";
        use_logical_path = true;
        use_os_path_sep = true;
      };
      directory.substitutions = {
        # Here is how you can shorten some long paths by text replacement;
        # similar to mapped_locations in Oh My Posh:;
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        # Keep in mind that the order matters. For example:;
        # "Important Documents" = "  ";
        # will not be replaced, because "Documents" was already substituted before.;
        # So either put "Important Documents" before "Documents" or use the substituted version:;
        # "Important  " = "  ";
        "Important " = " ";
      };
      docker_context = {
        format = "[$symbol$context]($style) ";
        style = "blue bold bg:0x06969A";
        symbol = " ";
        only_with_files = true;
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "docker-compose.yml"
          "docker-compose.yaml"
          "Dockerfile"
        ];
        detect_folders = [ ];
      };
      dotnet = {
        format = "[$symbol($version )(🎯 $tfm )]($style)";
        version_format = "v$raw";
        symbol = "🥅 ";
        style = "blue bold";
        heuristic = true;
        disabled = false;
        detect_extensions = [
          "csproj"
          "fsproj"
          "xproj"
        ];
        detect_files = [
          "global.json"
          "project.json"
          "Directory.Build.props"
          "Directory.Build.targets"
          "Packages.props"
        ];
        detect_folders = [ ];
      };
      elixir = {
        format = "[$symbol($version (OTP $otp_version) )]($style)";
        version_format = "v$raw";
        style = "bold purple bg:0x86BBD8";
        symbol = " ";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [ "mix.exs" ];
        detect_folders = [ ];
      };
      elm = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        style = "cyan bold bg:0x86BBD8";
        symbol = " ";
        disabled = false;
        detect_extensions = [ "elm" ];
        detect_files = [
          "elm.json"
          "elm-package.json"
          ".elm-version"
        ];
        detect_folders = [ "elm-stuff" ];
      };
      env_var = { };
      env_var.SHELL = {
        format = "[$symbol($env_value )]($style)";
        style = "grey bold italic dimmed";
        symbol = "e:";
        disabled = true;
        variable = "SHELL";
        default = "unknown shell";
      };
      env_var.USER = {
        format = "[$symbol($env_value )]($style)";
        style = "grey bold italic dimmed";
        symbol = "e:";
        disabled = true;
        default = "unknown user";
      };
      erlang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = " ";
        style = "bold red";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "rebar.config"
          "erlang.mk"
        ];
        detect_folders = [ ];
      };
      fill = {
        style = "bold black";
        symbol = ".";
        disabled = false;
      };
      gcloud = {
        format = "[$symbol$account(@$domain)(($region))(($project))]($style) ";
        symbol = "☁️ ";
        style = "bold blue";
        disabled = false;
      };
      gcloud.project_aliases = { };
      gcloud.region_aliases = { };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        symbol = " ";
        style = "bold purple bg:0xFCA17D";
        truncation_length = 9223372036854775807;
        truncation_symbol = "…";
        only_attached = false;
        always_show_remote = false;
        ignore_branches = [ ];
        disabled = false;
      };
      git_commit = {
        commit_hash_length = 7;
        format = "[($hash$tag)]($style) ";
        style = "green bold";
        only_detached = true;
        disabled = false;
        tag_symbol = " 🏷  ";
        tag_disabled = true;
      };
      git_metrics = {
        added_style = "bold green";
        deleted_style = "bold red";
        only_nonzero_diffs = true;
        format = "([+$added]($added_style) )([-$deleted]($deleted_style) )";
        disabled = false;
      };
      git_state = {
        am = "AM";
        am_or_rebase = "AM/REBASE";
        bisect = "BISECTING";
        cherry_pick = "🍒PICKING(bold red)";
        disabled = false;
        format = "([$state( $progress_current/$progress_total)]($style)) ";
        merge = "MERGING";
        rebase = "REBASING";
        revert = "REVERTING";
        style = "bold yellow";
      };
      git_status = {
        ahead = "🏎💨$count";
        behind = "😰$count";
        conflicted = "🏳";
        deleted = "🗑";
        disabled = false;
        diverged = "😵";
        # format = "([[$all_status$ahead_behind]]($style) )";
        ignore_submodules = false;
        modified = "📝";
        renamed = "👅";
        staged = "[++($count)](green)";
        stashed = "📦";
        style = "red bold bg:0xFCA17D";
        untracked = "🤷";
        up_to_date = "✓";
      };
      golang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = " ";
        style = "bold cyan bg:0x86BBD8";
        disabled = false;
        detect_extensions = [ "go" ];
        detect_files = [
          "go.mod"
          "go.sum"
          "glide.yaml"
          "Gopkg.yml"
          "Gopkg.lock"
          ".go-version"
        ];
        detect_folders = [ "Godeps" ];
      };
      haskell = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "λ ";
        style = "bold purple bg:0x86BBD8";
        disabled = false;
        detect_extensions = [
          "hs"
          "cabal"
          "hs-boot"
        ];
        detect_files = [
          "stack.yaml"
          "cabal.project"
        ];
        detect_folders = [ ];
      };
      helm = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "⎈ ";
        style = "bold white";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [
          "helmfile.yaml"
          "Chart.yaml"
        ];
        detect_folders = [ ];
      };
      hg_branch = {
        symbol = " ";
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
        truncation_length = 9223372036854775807;
        truncation_symbol = "…";
        disabled = true;
      };
      hostname = {
        disabled = false;
        format = "[$ssh_symbol](blue dimmed bold)[$hostname]($style) ";
        ssh_only = false;
        style = "green dimmed bold";
        trim_at = ".";
      };
      java = {
        disabled = false;
        format = "[$symbol($version )]($style)";
        style = "red dimmed bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        detect_extensions = [
          "java"
          "class"
          "jar"
          "gradle"
          "clj"
          "cljc"
        ];
        detect_files = [
          "pom.xml"
          "build.gradle.kts"
          "build.sbt"
          ".java-version"
          "deps.edn"
          "project.clj"
          "build.boot"
        ];
        detect_folders = [ ];
      };
      jobs = {
        threshold = 1;
        symbol_threshold = 0;
        number_threshold = 2;
        format = "[$symbol$number]($style) ";
        symbol = "✦";
        style = "bold blue";
        disabled = false;
      };
      julia = {
        disabled = false;
        format = "[$symbol($version )]($style)";
        style = "bold purple bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        detect_extensions = [ "jl" ];
        detect_files = [
          "Project.toml"
          "Manifest.toml"
        ];
        detect_folders = [ ];
      };
      kotlin = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🅺 ";
        style = "bold blue";
        kotlin_binary = "kotlin";
        disabled = false;
        detect_extensions = [
          "kt"
          "kts"
        ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      kubernetes = {
        disabled = false;
        format = "[$symbol$context( ($namespace))]($style) in ";
        style = "cyan bold";
        symbol = "⛵ ";
      };
      kubernetes.context_aliases = { };
      line_break = {
        disabled = false;
      };
      localip = {
        disabled = false;
        format = "[@$localipv4]($style) ";
        ssh_only = false;
        style = "yellow bold";
      };
      lua = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🌙 ";
        style = "bold blue";
        lua_binary = "lua";
        disabled = false;
        detect_extensions = [ "lua" ];
        detect_files = [ ".lua-version" ];
        detect_folders = [ "lua" ];
      };
      memory_usage = {
        disabled = false;
        format = "$symbol[$ram( | $swap)]($style) ";
        style = "white bold dimmed";
        symbol = " ";
        # threshold = 75;
        threshold = -1;
      };
      nim = {
        format = "[$symbol($version )]($style)";
        style = "yellow bold bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [
          "nim"
          "nims"
          "nimble"
        ];
        detect_files = [ "nim.cfg" ];
        detect_folders = [ ];
      };
      nix_shell = {
        format = "[$symbol$state( ($name))]($style) ";
        disabled = false;
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
        style = "bold blue";
        symbol = " ";
      };
      nodejs = {
        format = "[$symbol($version )]($style)";
        not_capable_style = "bold red";
        style = "bold green bg:0x86BBD8";
        symbol = " ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [
          "js"
          "mjs"
          "cjs"
          "ts"
          "mts"
          "cts"
        ];
        detect_files = [
          "package.json"
          ".node-version"
          ".nvmrc"
        ];
        detect_folders = [ "node_modules" ];
      };
      ocaml = {
        format = "[$symbol($version )(($switch_indicator$switch_name) )]($style)";
        global_switch_indicator = "";
        local_switch_indicator = "*";
        style = "bold yellow";
        symbol = "🐫 ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [
          "opam"
          "ml"
          "mli"
          "re"
          "rei"
        ];
        detect_files = [
          "dune"
          "dune-project"
          "jbuild"
          "jbuild-ignore"
          ".merlin"
        ];
        detect_folders = [
          "_opam"
          "esy.lock"
        ];
      };
      openstack = {
        format = "[$symbol$cloud(($project))]($style) ";
        symbol = "☁️  ";
        style = "bold yellow";
        disabled = false;
      };
      package = {
        format = "[$symbol$version]($style) ";
        symbol = "📦 ";
        style = "208 bold";
        display_private = false;
        disabled = false;
        version_format = "v$raw";
      };
      perl = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🐪 ";
        style = "149 bold";
        disabled = false;
        detect_extensions = [
          "pl"
          "pm"
          "pod"
        ];
        detect_files = [
          "Makefile.PL"
          "Build.PL"
          "cpanfile"
          "cpanfile.snapshot"
          "META.json"
          "META.yml"
          ".perl-version"
        ];
        detect_folders = [ ];
      };
      php = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🐘 ";
        style = "147 bold";
        disabled = false;
        detect_extensions = [ "php" ];
        detect_files = [
          "composer.json"
          ".php-version"
        ];
        detect_folders = [ ];
      };
      pulumi = {
        format = "[$symbol($username@)$stack]($style) ";
        version_format = "v$raw";
        symbol = " ";
        style = "bold 5";
        disabled = false;
      };
      purescript = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "<=> ";
        style = "bold white";
        disabled = false;
        detect_extensions = [ "purs" ];
        detect_files = [ "spago.dhall" ];
        detect_folders = [ ];
      };
      python = {
        format = "[$symbol$pyenv_prefix($version )(($virtualenv) )]($style)";
        python_binary = [
          "python"
          "python3"
          "python2"
        ];
        pyenv_prefix = "pyenv ";
        pyenv_version_name = true;
        style = "yellow bold";
        symbol = "🐍 ";
        version_format = "v$raw";
        disabled = false;
        detect_extensions = [ "py" ];
        detect_files = [
          "requirements.txt"
          ".python-version"
          "pyproject.toml"
          "Pipfile"
          "tox.ini"
          "setup.py"
          "__init__.py"
        ];
        detect_folders = [ ];
      };
      red = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🔺 ";
        style = "red bold";
        disabled = false;
        detect_extensions = [
          "red"
          "reds"
        ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      rlang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        style = "blue bold";
        symbol = "📐 ";
        disabled = false;
        detect_extensions = [
          "R"
          "Rd"
          "Rmd"
          "Rproj"
          "Rsx"
        ];
        detect_files = [ ".Rprofile" ];
        detect_folders = [ ".Rproj.user" ];
      };
      ruby = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "💎 ";
        style = "bold red";
        disabled = false;
        detect_extensions = [ "rb" ];
        detect_files = [
          "Gemfile"
          ".ruby-version"
        ];
        detect_folders = [ ];
        detect_variables = [
          "RUBY_VERSION"
          "RBENV_VERSION"
        ];
      };
      rust = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🦀 ";
        style = "bold red bg:0x86BBD8";
        disabled = false;
        detect_extensions = [ "rs" ];
        detect_files = [ "Cargo.toml" ];
        detect_folders = [ ];
      };
      scala = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        disabled = false;
        style = "red bold";
        symbol = "🆂 ";
        detect_extensions = [
          "sbt"
          "scala"
        ];
        detect_files = [
          ".scalaenv"
          ".sbtenv"
          "build.sbt"
        ];
        detect_folders = [ ".metals" ];
      };
      shell = {
        format = "[$indicator]($style) ";
        bash_indicator = "bsh";
        cmd_indicator = "cmd";
        elvish_indicator = "esh";
        fish_indicator = "";
        ion_indicator = "ion";
        nu_indicator = "nu";
        powershell_indicator = "_";
        style = "white bold";
        tcsh_indicator = "tsh";
        unknown_indicator = "mystery shell";
        xonsh_indicator = "xsh";
        zsh_indicator = "zsh";
        disabled = false;
      };
      shlvl = {
        threshold = 2;
        format = "[$symbol$shlvl]($style) ";
        symbol = "↕️  ";
        repeat = false;
        style = "bold yellow";
        disabled = true;
      };
      singularity = {
        format = "[$symbol[$env]]($style) ";
        style = "blue bold dimmed";
        symbol = "📦 ";
        disabled = false;
      };
      spack = {
        truncation_length = 1;
        format = "[$symbol$environment]($style) ";
        symbol = "🅢 ";
        style = "blue bold";
        disabled = false;
      };
      status = {
        format = "[$symbol$status]($style) ";
        map_symbol = true;
        not_executable_symbol = "🚫";
        not_found_symbol = "🔍";
        pipestatus = false;
        pipestatus_format = "[$pipestatus] => [$symbol$common_meaning$signal_name$maybe_int]($style)";
        pipestatus_separator = "|";
        recognize_signal_code = true;
        signal_symbol = "⚡";
        style = "bold red bg:blue";
        success_symbol = "🟢 SUCCESS";
        symbol = "🔴 ";
        disabled = true;
      };
      sudo = {
        format = "[as $symbol]($style)";
        symbol = "🧙 ";
        style = "bold blue";
        allow_windows = false;
        disabled = true;
      };
      swift = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "🐦 ";
        style = "bold 202";
        disabled = false;
        detect_extensions = [ "swift" ];
        detect_files = [ "Package.swift" ];
        detect_folders = [ ];
      };
      terraform = {
        format = "[$symbol$workspace]($style) ";
        version_format = "v$raw";
        symbol = "💠 ";
        style = "bold 105";
        disabled = false;
        detect_extensions = [
          "tf"
          "tfplan"
          "tfstate"
        ];
        detect_files = [ ];
        detect_folders = [ ".terraform" ];
      };
      time = {
        format = "[$symbol $time]($style) ";
        style = "bold yellow bg:0x33658A";
        use_12hr = false;
        disabled = false;
        utc_time_offset = "local";
        # time_format = "%R"; # Hour:Minute Format;
        time_format = "%T"; # Hour:Minute:Seconds Format;
        time_range = "-";
      };
      username = {
        format = "[$user]($style) ";
        show_always = true;
        style_root = "red bold bg:0x9A348E";
        style_user = "yellow bold bg:0x9A348E";
        disabled = false;
      };
      vagrant = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "⍱ ";
        style = "cyan bold";
        disabled = false;
        detect_extensions = [ ];
        detect_files = [ "Vagrantfile" ];
        detect_folders = [ ];
      };
      vcsh = {
        symbol = "";
        style = "bold yellow";
        format = "[$symbol$repo]($style) ";
        disabled = false;
      };
      vlang = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "V ";
        style = "blue bold";
        disabled = false;
        detect_extensions = [ "v" ];
        detect_files = [
          "v.mod"
          "vpkg.json"
          ".vpkg-lock.json"
        ];
        detect_folders = [ ];
      };
      zig = {
        format = "[$symbol($version )]($style)";
        version_format = "v$raw";
        symbol = "↯ ";
        style = "bold yellow";
        disabled = false;
        detect_extensions = [ "zig" ];
        detect_files = [ ];
        detect_folders = [ ];
      };
      custom = { };
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
