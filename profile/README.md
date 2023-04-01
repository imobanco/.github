# Hi there 👋



## Template

1)
```bash
command -v curl || (command -v apt && sudo apt-get update && sudo apt-get install -y curl)
command -v curl || (command -v apk && sudo apk add --no-cache -y curl)


NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s -- --no-daemon \
&& . "$HOME"/.nix-profile/etc/profile.d/nix.sh

export NIX_CONFIG='extra-experimental-features = nix-command flakes'
```


Existem 3 tipos de configurações, descritos nas próximas seções.

1.1) Apenas programas CLI:

```bash
# Precisa das variáveis de ambiente USER e HOME

DIRECTORY_TO_CLONE=/home/"$USER"/.config/nixpkgs

nix \
shell \
github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb#{git,bashInteractive,coreutils,gnused,home-manager} \
--command \
bash <<-EOF
    echo $DIRECTORY_TO_CLONE
    rm -frv $DIRECTORY_TO_CLONE
    mkdir -pv $DIRECTORY_TO_CLONE

    cd $DIRECTORY_TO_CLONE
    
    nix \
    flake \
    init \
    --template \
    github:PedroRegisPOAR/.github/feature/dx-with-nix-and-home-manager#templates.x86_64-linux.startConfig
    
    sed -i 's/username = ".*";/username = "'$USER'";/g' flake.nix \
    && git init \
    && git status \
    && git add . \
    && nix flake update --override-input nixpkgs github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb \
    && git status \
    && git add .
    
    # TODO: ainda não foi testado
    nix \
    --option eval-cache false \
    --option extra-trusted-public-keys binarycache-1:vBBc6CVmjXj5dPH0x5zPPZvkc1U9QbVoSqHcUcx6cSY= \
    --option extra-substituters https://playing-bucket-nix-cache-test.s3.amazonaws.com \
    build \
    --keep-failed \
    --max-jobs 0 \
    --no-link \
    --print-build-logs \
    --print-out-paths \
    ~/.config/nixpkgs#homeConfigurations.vagrant.activationPackage
    
    export NIXPKGS_ALLOW_UNFREE=1 \
    && home-manager switch -b backuphm --impure --flake /home/"$USER"/.config/nixpkgs \
    && home-manager generations
    
    
    #
    TARGET_SHELL='zsh' \
    && FULL_TARGET_SHELL=/home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
    && echo \
    && ls -al "\$FULL_TARGET_SHELL" \
    && echo \
    && echo "\$FULL_TARGET_SHELL" | sudo tee -a /etc/shells \
    && echo \
    && sudo \
          -k \
          usermod \
          -s \
          /home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
          "$USER"
EOF
```



```bash
# Precisa das variáveis de ambiente USER e HOME

DIRECTORY_TO_CLONE=/home/"$USER"/.config/nixpkgs

nix \
shell \
github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb#{git,bashInteractive,coreutils,gnused,home-manager} \
--command \
bash <<-EOF
    echo $DIRECTORY_TO_CLONE
    rm -frv $DIRECTORY_TO_CLONE
    mkdir -pv $DIRECTORY_TO_CLONE

    cd $DIRECTORY_TO_CLONE
    
    nix \
    flake \
    init \
    --template \
    github:PedroRegisPOAR/.github/feature/dx-with-nix-and-home-manager#templates.x86_64-linux.startConfig
    
    sed -i 's/username = ".*";/username = "'"$(id -un)"'";/g' flake.nix \
    && sed -i 's/hostname = ".*";/hostname = "'"$(hostname)"'";/g' flake.nix \
    && git init \
    && git status \
    && git add . \
    && nix flake update --override-input nixpkgs github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb \
    && git status \
    && git add .
    
    export NIXPKGS_ALLOW_UNFREE=1 

    nix \
    build \
    --impure \
    --eval-store auto \
    --keep-failed \
    --max-jobs 0 \
    --no-link \
    --print-build-logs \
    --print-out-paths \
    --store ssh-ng://builder \
    --substituters '' \
    ~/.config/nixpkgs#homeConfigurations."$(id -un)"-"$(hostname)".activationPackage

    && home-manager switch -b backuphm --impure --flake /home/"$USER"/.config/nixpkgs#"$(id -un)"-"$(hostname)" \
    && home-manager generations


    #
    TARGET_SHELL='zsh' \
    && FULL_TARGET_SHELL=/home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
    && echo \
    && ls -al "\$FULL_TARGET_SHELL" \
    && echo \
    && echo "\$FULL_TARGET_SHELL" | sudo tee -a /etc/shells \
    && echo \
    && sudo \
          -k \
          usermod \
          -s \
          /home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
          "$USER"
EOF
```


1.2) Apenas programas CLI, slim:

```bash
# Precisa das variáveis de ambiente USER e HOME

DIRECTORY_TO_CLONE=/home/"$USER"/.config/nixpkgs

nix \
shell \
github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb#{git,bashInteractive,coreutils,gnused,home-manager} \
--command \
bash <<-EOF
    echo $DIRECTORY_TO_CLONE
    rm -frv $DIRECTORY_TO_CLONE
    mkdir -pv $DIRECTORY_TO_CLONE

    cd $DIRECTORY_TO_CLONE
    
    nix \
    flake \
    init \
    --template \
    github:PedroRegisPOAR/.github/feature/dx-with-nix-and-home-manager#templates.x86_64-linux.startSlimConfig
    
    sed -i 's/username = ".*";/username = "'$USER'";/g' flake.nix \
    && git init \
    && git status \
    && git add . \
    && nix flake update --override-input nixpkgs github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb \
    && git status \
    && git add .
    
    
    export NIXPKGS_ALLOW_UNFREE=1 \
    && home-manager switch -b backuphm --impure --flake /home/"$USER"/.config/nixpkgs \
    && home-manager generations
    
    
    #
    TARGET_SHELL='zsh' \
    && FULL_TARGET_SHELL=/home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
    && echo \
    && ls -al "\$FULL_TARGET_SHELL" \
    && echo \
    && echo "\$FULL_TARGET_SHELL" | sudo tee -a /etc/shells \
    && echo \
    && sudo \
          -k \
          usermod \
          -s \
          /home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
          "$USER"
EOF
```


1.3) Programas com interface gráfica (precisa de no mínimo 22Gigas de espaço em disco):

```bash
# Precisa das variáveis de ambiente USER e HOME

DIRECTORY_TO_CLONE=/home/"$USER"/.config/nixpkgs

nix \
shell \
github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb#{git,bashInteractive,coreutils,gnused,home-manager} \
--command \
bash <<-EOF
    echo $DIRECTORY_TO_CLONE
    rm -frv $DIRECTORY_TO_CLONE
    mkdir -pv $DIRECTORY_TO_CLONE

    cd $DIRECTORY_TO_CLONE
    
    nix \
    flake \
    init \
    --template \
    github:PedroRegisPOAR/.github/feature/dx-with-nix-and-home-manager#templates.x86_64-linux.baseStartConfigGraphicalFull
    
    sed -i 's/username = ".*";/username = "'$USER'";/g' flake.nix \
    && git init \
    && git status \
    && git add . \
    && nix flake update --override-input nixpkgs github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb \
    && git status \
    && git add .
    
    
    export NIXPKGS_ALLOW_UNFREE=1 \
    && home-manager switch -b backuphm --impure --flake /home/"$USER"/.config/nixpkgs \
    && home-manager generations
    
    
    #
    TARGET_SHELL='zsh' \
    && FULL_TARGET_SHELL=/home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
    && echo \
    && ls -al "\$FULL_TARGET_SHELL" \
    && echo \
    && echo "\$FULL_TARGET_SHELL" | sudo tee -a /etc/shells \
    && echo \
    && sudo \
          -k \
          usermod \
          -s \
          /home/"$USER"/.nix-profile/bin/"\$TARGET_SHELL" \
          "$USER"
EOF
```

2)
```bash
sudo reboot
```

3) Adicionando uma nova chave ssh a sua conta do github

Use o script `generate-new-ed25519-key-pair` e acesse o link:
https://github.com/settings/ssh/new


4) Ir para o repositório privado do Imobanco?
https://github.com/imobanco/.config-nixpkgs

5) WIP

```bash
# rm -frv /home/"$USER"/.config/nixpkgs/.git
```



### Mac


```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
&& echo 'eval "$(/opt/homebrew/bin/brew shellenv)' >> "$HOME"/.zprofile
```



```bash
brew install hello
```


```bash
brew uninstall hello
```

```bash
NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s

export NIX_CONFIG='extra-experimental-features = nix-command flakes'
```


```bash
nix build -L --no-link --rebuild nixpkgs#hello
```

```bash
nix build -L nixpkgs#pkgsCross.x86_64-embedded.hello
```

```bash
nix build -L nixpkgs#pkgsCross.x86_64-embedded.pkgsStatic.hello
```
