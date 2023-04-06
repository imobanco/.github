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


# export DUMMY_USER=alpine
export DUMMY_USER="$USER"
# export DUMMY_USER="$(id -un)"

# TODO: Mac
# export DUMMY_HOME="$HOME"
export DUMMY_HOME=/home/"$USER"

# export DUMMY_HOSTNAME=alpine316.localdomain
export DUMMY_HOSTNAME="$(hostname)"

HM_ATTR_FULL_NAME='"'"$DUMMY_USER"-"$DUMMY_HOSTNAME"'"'
FLAKE_ATTR="$DIRECTORY_TO_CLONE""#homeConfigurations."'\"'"$HM_ATTR_FULL_NAME"'\"'".activationPackage"


time \
nix \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters https://playing-bucket-nix-cache-test.s3.amazonaws.com \
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
    
    sed -i 's/username = ".*";/username = "'$DUMMY_USER'";/g' flake.nix \
    && sed -i 's/hostname = ".*";/hostname = "'"$DUMMY_HOSTNAME"'";/g' flake.nix \
    && git init \
    && git status \
    && git add . \
    && nix flake update --override-input nixpkgs github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb \
    && git status \
    && git add .
    
    echo "$FLAKE_ATTR"
    # TODO: --max-jobs 0 \
    nix \
    --option eval-cache false \
    --option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
    --option extra-substituters https://playing-bucket-nix-cache-test.s3.amazonaws.com \
    build \
    --keep-failed \
    --max-jobs 0 \
    --no-link \
    --print-build-logs \
    --print-out-paths \
    "$FLAKE_ATTR"
    
    export NIXPKGS_ALLOW_UNFREE=1 \
    && home-manager switch -b backuphm --impure --flake "$DIRECTORY_TO_CLONE"#"$HM_ATTR_FULL_NAME" \
    && home-manager generations
    
    #
    TARGET_SHELL='zsh' \
    && FULL_TARGET_SHELL=/home/"$DUMMY_USER"/.nix-profile/bin/"\$TARGET_SHELL" \
    && echo \
    && ls -al "\$FULL_TARGET_SHELL" \
    && echo \
    && echo "\$FULL_TARGET_SHELL" | sudo tee -a /etc/shells \
    && echo \
    && sudo \
          -k \
          usermod \
          -s \
          /home/"$DUMMY_USER"/.nix-profile/bin/"\$TARGET_SHELL" \
          "$DUMMY_USER"
    
EOF
```

```bash
nix \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters https://playing-bucket-nix-cache-test.s3.amazonaws.com \
build \
--keep-failed \
--max-jobs 0 \
--no-link \
--print-build-logs \
--print-out-paths \
/nix/store/8c3ssm2avqxyfhcz7jik9s857s3kyz0q-home-manager-generation
```

```bash
tee ~/.ssh/config <<EOF
Host builder
    HostName localhost
    User nixuser
    Port 2221
    PubkeyAcceptedKeyTypes ssh-ed25519
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
    LogLevel INFO
EOF
```


```bash
# Precisa das variáveis de ambiente USER e HOME

# DIRECTORY_TO_CLONE="$(pwd)"/test-home-manager-s3-cache
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
    --no-link \
    --print-build-logs \
    --print-out-paths \
    '.#homeConfigurations."$(id -un)"-"$(hostname)".activationPackage'
    
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

DIRECTORY_TO_CLONE="$(pwd)"/test-home-manager-s3-cache


export DUMMY_USER=vagrant
# export USER="$USER"
# export USER="$(id -un)"

# TODO: Mac
# export HOME="$HOME"
export DUMMY_HOME=/home/"$USER"

export DUMMY_HOSTNAME=alpine316.localdomain
# export HOSTNAME="$(hostname)"


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
    
    sed -i 's/username = ".*";/username = "'"$DUMMY_USER"'";/g' flake.nix \
    && sed -i 's/hostname = ".*";/hostname = "'"$DUMMY_HOSTNAME"'";/g' flake.nix \
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
    --substituters "" \
    .#homeConfigurations.\""$DUMMY_USER"-"$DUMMY_HOSTNAME"\".activationPackage
EOF
```


Running it directly in the builder:
```bash
# Precisa das variáveis de ambiente USER e HOME

DIRECTORY_TO_CLONE="$(pwd)"/test-home-manager-s3-cache


export DUMMY_USER=alpine
# export USER="$USER"
# export USER="$(id -un)"

# TODO: Mac
# export HOME="$HOME"
export DUMMY_HOME=/home/"$USER"

export DUMMY_HOSTNAME=alpine316.localdomain
# export HOSTNAME="$(hostname)"

HM_ATTR_FULL_NAME='"'"$DUMMY_USER"-"$DUMMY_HOSTNAME"'"'
FLAKE_ATTR=".#homeConfigurations.""$HM_ATTR_FULL_NAME"".activationPackage"


time \
nix \
shell \
--refresh \
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
    
    sed -i 's/username = ".*";/username = "'"$DUMMY_USER"'";/g' flake.nix \
    && sed -i 's/hostname = ".*";/hostname = "'"$DUMMY_HOSTNAME"'";/g' flake.nix \
    && git init \
    && git status \
    && git add . \
    && nix flake update --override-input nixpkgs github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb \
    && git status \
    && git add .
EOF


cd $DIRECTORY_TO_CLONE

# echo "$FLAKE_ATTR"
# nix eval --raw "$FLAKE_ATTR"

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
--substituters "" \
"$FLAKE_ATTR"


CACHE=s3://playing-bucket-nix-cache-test/

nix-store --query --requisites --include-outputs --force-realise \
$(nix path-info "$FLAKE_ATTR") \
| xargs -I{} nix \
    copy \
    -vvvv \
    --no-check-sigs \
    {} \
    --to 's3://playing-bucket-nix-cache-test'


#nix copy --no-check-sigs --eval-store auto -vvvv --to "$CACHE" \
#$(nix eval --raw "$FLAKE_ATTR")
```


export NIXPKGS_ALLOW_UNFREE=1 

nix-store --query --requisites --include-outputs \
$(nix path-info --impure "$FLAKE_ATTR" ) | wc -l

```bash
export NIXPKGS_ALLOW_UNFREE=1 

nix-store --query --requisites --include-outputs \
$(nix path-info --impure ~/.config/nixpkgs#homeConfigurations."$USER"-"$(hostname)".activationPackage ) | wc -l
```

```bash
nix-store --query --requisites --include-outputs \
$(nix path-info --impure --derivation ~/.config/nixpkgs#homeConfigurations."$USER"-"$(hostname)".activationPackage ) | wc -l
```


```bash
rm -frv "$DIRECTORY_TO_CLONE"
```

```bash
nix \
--option trusted-public-keys binarycache-1:PbJHKsLPq2DJ2OXhvqk1VgwFl04tvaHz3PzjZrrFNh0= \
store \
ls \
--store 's3://playing-bucket-nix-cache-test/' \
--long \
--recursive \
$(nix eval --raw "$FLAKE_ATTR")
```


```bash
nix \
--option trusted-public-keys binarycache-1:PbJHKsLPq2DJ2OXhvqk1VgwFl04tvaHz3PzjZrrFNh0= \
store \
ls \
--store 's3://playing-bucket-nix-cache-test/' \
--long \
--recursive \
$(nix eval --raw github:NixOS/nixpkgs/3954218cf613eba8e0dcefa9abe337d26bc48fd0#blender)
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
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/fc8acb0828f89f8aa83162000db1b49de71fa5d8/install.sh)" \
&& echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME"/.zprofile
```



```bash
brew install hello
```


```bash
brew uninstall hello
```

#### Mac and nix

```bash
NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s \
&& echo 'export NIX_CONFIG="extra-experimental-features = "nix-command flakes"' >> "$HOME"/.zprofile
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
