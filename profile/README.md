# Hi there 👋



## Template


1)

Versão curta:
```bash
wget -qO- http://ix.io/4tTQ | sh \
&& . "$HOME"/."$(basename $SHELL)"rc \
&& nix flake --version
```

Versão longa:
```bash
command -v curl || (command -v apt && sudo apt-get update && sudo apt-get install -y curl)
command -v curl || (command -v apk && sudo apk add --no-cache curl)


NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s -- --no-daemon \
&& . "$HOME"/.nix-profile/etc/profile.d/nix.sh

NAME_SHELL=$(basename $SHELL) \
&& echo 'export NIX_CONFIG="extra-experimental-features = nix-command flakes"' >> "$HOME"/."$NAME_SHELL"rc \
&& echo '. "$HOME"/.nix-profile/etc/profile.d/nix.sh' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'eval "$(direnv hook '"$NAME_SHELL"')"' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'export NIX_CONFIG="extra-experimental-features = nix-command flakes"' >> "$HOME"/.profile \
&& echo '. "$HOME"/.nix-profile/etc/profile.d/nix.sh' >> "$HOME"/.profile \
&& echo 'eval "$(direnv hook '"$NAME_SHELL"')"' >> "$HOME"/.profile \
&& . "$HOME"/."$NAME_SHELL"rc \
&& . "$HOME"/.profile \
&& nix flake --version \
&& nix --extra-experimental-features 'nix-command flakes' profile install -vvv nixpkgs#direnv nixpkgs#git \
&& . "$HOME"/."$NAME_SHELL"rc \
&& . "$HOME"/.profile
```

Crie um arquivo e copie e cole o bloco de código acima no arquivo.
```bash
vi arquivo.txt
```

Após salvar:
```bash
cat arquivo.txt | curl -F 'f:1=<-' ix.io
```


Existem 3 tipos de configurações, descritos nas próximas seções: apenas CLI, apenas CLI slim, e com 
programas com interface gráfica.
 
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


BASE_FLAKE_URI='github:NixOS/nixpkgs/f5ffd5787786dde3a8bf648c7a1b5f78c4e01abb#'

time \
nix \
--extra-experimental-features 'nix-command flakes' \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters "s3://playing-bucket-nix-cache-test" \
shell \
"$BASE_FLAKE_URI"git \
"$BASE_FLAKE_URI"bashInteractive \
"$BASE_FLAKE_URI"coreutils \
"$BASE_FLAKE_URI"gnused \
"$BASE_FLAKE_URI"home-manager \
--command \
bash <<-EOF
    echo $DIRECTORY_TO_CLONE
    rm -frv $DIRECTORY_TO_CLONE
    mkdir -pv $DIRECTORY_TO_CLONE

    cd $DIRECTORY_TO_CLONE
    
    export NIX_CONFIG='extra-experimental-features = nix-command flakes'
    
    echo $NIX_CONFIG
    
    nix \
    --extra-experimental-features 'nix-command flakes' \
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
    --extra-experimental-features 'nix-command flakes' \
    --option eval-cache false \
    --option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
    --option extra-substituters "s3://playing-bucket-nix-cache-test" \
    build \
    --keep-failed \
    --max-jobs 0 \
    --no-link \
    --print-build-logs \
    --print-out-paths \
    "$FLAKE_ATTR"
    
    nix --extra-experimental-features 'nix-command flakes' -vvv profile remove '.*'

    export NIXPKGS_ALLOW_UNFREE=1 \
    && home-manager switch -b backuphm --impure --flake \
         "$DIRECTORY_TO_CLONE"#"$HM_ATTR_FULL_NAME" \
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
          /usr/sbin/usermod \
          -s \
          /home/"$DUMMY_USER"/.nix-profile/bin/"\$TARGET_SHELL" \
          "$DUMMY_USER"
    
EOF
```


Versão curta:
```bash
wget -qO- http://ix.io/4uz3 | sh \
&& . "$HOME"/."$(basename $SHELL)"rc \
&& nix flake --version
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

    nix profile remove '.*'   
    
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
    
    nix profile remove '.*'
    
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
&& echo 'export NIX_CONFIG="extra-experimental-features = 'nix-command flakes'"' >> "$HOME"/.zprofile
```

Feche o terminal.

Abra o terminal:
```bash
nix profile install nixpkgs#hello nixpkgs#tmate
```

```bash
nix eval --impure --raw --expr 'builtins.currentSystem'
```


```bash
nix build --no-link --print-build-logs --rebuild nixpkgs#hello
```

```bash
nix build --print-build-logs nixpkgs#pkgsCross.x86_64-embedded.hello
```

```bash
nix build --print-build-logs nixpkgs#pkgsCross.x86_64-embedded.pkgsStatic.hello
```

```bash
nix build --no-link --print-build-logs github:NixOS/nixpkgs/nixpkgs-unstable#darwin.builder
```


```bash
EXPR_NIX='
  (
    with builtins.getFlake "github:NixOS/nixpkgs/da0b0bc6a5d699a8a9ffbf9e1b19e8642307062a";
    with legacyPackages.${builtins.currentSystem};
    python3.withPackages (p: with p; [ pandas ])
  )
'

# --rebuild \
nix \
build \
--impure \
--option enforce-determinism false \
--no-link \
--print-build-logs \
--expr \
"$EXPR_NIX"


nix \
shell \
--impure \
--expr \
"$EXPR_NIX" \
--command \
python3 -c 'import pandas as pd; pd.DataFrame(); print(pd.__version__)'
```

Quebrado:
```bash
nix \
build \
--impure \
--no-enforce-determinism \
--no-link \
--print-build-logs \
--rebuild \
--expr \
"$EXPR_NIX"
```


Quebrado:
```bash
nix \
build \
--impure \
--builders "" \
--no-link \
--print-build-logs \
--rebuild \
--expr \
"$EXPR_NIX"
```


#### x86_64-linux with podman

Podman

```bash
nix \
build \
--max-jobs auto \
--no-link \
--no-show-trace \
--print-build-logs \
#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm
```

```bash
nix \
build \
--max-jobs auto \
--no-link \
--no-show-trace \
--print-build-logs \
github:PedroRegisPOAR/.github/6687778e4f350b968804a3f019248794409e979d#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm

send-signed-closure-run-time-of-flake-uri-attr-to-bucket \
github:PedroRegisPOAR/.github/6687778e4f350b968804a3f019248794409e979d#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm
```


```bash
time \
nix \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters "s3://playing-bucket-nix-cache-test" \
build \
--keep-failed \
--max-jobs 0 \
--no-link \
--no-show-trace \
--print-build-logs \
--print-out-paths \
github:PedroRegisPOAR/.github/6687778e4f350b968804a3f019248794409e979d#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm
```


```bash
mkdir -pv ~/sandbox/sandbox && cd $_

export HOST_MAPPED_PORT=10022
export REMOVE_DISK=true
export QEMU_NET_OPTS='hostfwd=tcp::'"$HOST_MAPPED_PORT"'-:'"$HOST_MAPPED_PORT"',hostfwd=tcp::8000-:8000'
export QEMU_OPTS='-nographic'
export SHARED_DIR="$(pwd)"

"$REMOVE_DISK" && rm -fv nixos.qcow2
# nc 1>/dev/null 2>/dev/null || nix profile install nixpkgs#netcat
# nc -v -4 localhost "$HOST_MAPPED_PORT" -w 1 -z && echo 'There is something already using the port:'"$HOST_MAPPED_PORT"

# sudo lsof -t -i tcp:"$HOST_MAPPED_PORT" -s tcp:listen
# sudo lsof -t -i tcp:"$HOST_MAPPED_PORT" -s tcp:listen | sudo xargs --no-run-if-empty kill

cat << 'EOF' >> id_ed25519
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCsoS8eR1Ot8ySeS8eI/jUwvzkGe1npaHPMvjp+Ou5JcgAAAIjoIwah6CMG
oQAAAAtzc2gtZWQyNTUxOQAAACCsoS8eR1Ot8ySeS8eI/jUwvzkGe1npaHPMvjp+Ou5Jcg
AAAEAbL0Z61S8giktfR53dZ2fztctV/0vML24doU0BMGLRZqyhLx5HU63zJJ5Lx4j+NTC/
OQZ7Weloc8y+On467klyAAAAAAECAwQF
-----END OPENSSH PRIVATE KEY-----
EOF

chmod -v 0600 id_ed25519


#nix \
#--option eval-cache false \
#--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
#--option extra-substituters "s3://playing-bucket-nix-cache-test" \
#build \
#--keep-failed \
#--max-jobs 0 \
#--no-link \
#--no-show-trace \
#--print-build-logs \
#--print-out-paths \
#github:PedroRegisPOAR/.github/fe92d991ab7f32a6d3589a33a1b473d5f61fa9c9#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm

nix \
run \
github:PedroRegisPOAR/.github/6687778e4f350b968804a3f019248794409e979d#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm \
< /dev/null &


while ! ssh -i id_ed25519 -o ConnectTimeout=1 -o StrictHostKeyChecking=no nixuser@localhost -p "$HOST_MAPPED_PORT" <<<'nix flake metadata nixpkgs'; do \
  echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done \
&& ssh-keygen -R '[localhost]:'"$HOST_MAPPED_PORT"; \
ssh \
-i id_ed25519 \
-X \
-o StrictHostKeyChecking=no \
nixuser@localhost \
-p "$HOST_MAPPED_PORT"

#<<COMMANDS
#id
#COMMANDS
#"$REMOVE_DISK" && rm -fv nixos.qcow2 id_ed25519
```

```bash
export CONTAINER_HOST=ssh://nixuser@localhost:10022/run/user/1234/podman/podman.sock

podman run -it --rm docker.io/library/alpine sh -c 'cat /etc/os-*release'
```
Refs.:
- 


Broken:
```bash
ssh \
-fnNT \
-L/tmp/podman.sock:/run/user/1234/podman/podman.sock \
-i id_ed25519 \
ssh://nixuser@localhost:10022 \
-o StreamLocalBindUnlink=yes

podman run -it --rm docker.io/library/alpine sh -c 'cat /etc/os-*release'
```
Refs.:
- https://github.com/containers/podman/issues/11397#issuecomment-1321090051

```bash
sudo netstat -nptl
```
Refs.:
- https://serverfault.com/a/1083002


##### podman system connection add

```bash
export DOCKER_HOST = "ssh://root@podman-romote-host"
podman system connection add --identity ~/.ssh/id_rsa production $DOCKER_HOST
podman run hello-world
```
Refs.:
- https://stackoverflow.com/a/75533656
- https://github.com/containers/podman/issues/11668#issuecomment-947983711


```bash
podman --remote --identity id_ed25519 --url ssh://nixuser@localhost:10022 images
```
Refs.:
- https://stackoverflow.com/a/74634171


#### x86_64-linux with docker

Docker

```bash
nix \
build \
--max-jobs auto \
--no-link \
--no-show-trace \
--print-build-logs \
#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxDocker.config.system.build.vm
```

```bash
nix \
build \
--max-jobs auto \
--no-link \
--no-show-trace \
--print-build-logs \
github:PedroRegisPOAR/.github/c6ca5765957381ac7fa55b50462f62441ebee989#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxDocker.config.system.build.vm

send-signed-closure-run-time-of-flake-uri-attr-to-bucket \
github:PedroRegisPOAR/.github/c6ca5765957381ac7fa55b50462f62441ebee989#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxDocker.config.system.build.vm
```


```bash
time \
nix \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters "s3://playing-bucket-nix-cache-test" \
build \
--keep-failed \
--max-jobs 0 \
--no-link \
--no-show-trace \
--print-build-logs \
--print-out-paths \
github:PedroRegisPOAR/.github/c6ca5765957381ac7fa55b50462f62441ebee989#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxDocker.config.system.build.vm
```


```bash
mkdir -pv ~/sandbox/sandbox && cd $_

export HOST_MAPPED_PORT=10022
export REMOVE_DISK=true
export QEMU_NET_OPTS='hostfwd=tcp::'"$HOST_MAPPED_PORT"'-:'"$HOST_MAPPED_PORT"',hostfwd=tcp::8000-:8000'
export QEMU_OPTS='-nographic'
export SHARED_DIR="$(pwd)"


pgrep qemu | xargs kill 
"$REMOVE_DISK" && rm -fv nixos.qcow2

# nc 1>/dev/null 2>/dev/null || nix profile install nixpkgs#netcat
# nc -v -4 localhost "$HOST_MAPPED_PORT" -w 1 -z && echo 'There is something already using the port:'"$HOST_MAPPED_PORT"

# sudo lsof -t -i tcp:"$HOST_MAPPED_PORT" -s tcp:listen
# sudo lsof -t -i tcp:"$HOST_MAPPED_PORT" -s tcp:listen | sudo xargs --no-run-if-empty kill

cat << 'EOF' >> id_ed25519
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCsoS8eR1Ot8ySeS8eI/jUwvzkGe1npaHPMvjp+Ou5JcgAAAIjoIwah6CMG
oQAAAAtzc2gtZWQyNTUxOQAAACCsoS8eR1Ot8ySeS8eI/jUwvzkGe1npaHPMvjp+Ou5Jcg
AAAEAbL0Z61S8giktfR53dZ2fztctV/0vML24doU0BMGLRZqyhLx5HU63zJJ5Lx4j+NTC/
OQZ7Weloc8y+On467klyAAAAAAECAwQF
-----END OPENSSH PRIVATE KEY-----
EOF

chmod -v 0600 id_ed25519


#nix \
#--option eval-cache false \
#--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
#--option extra-substituters "s3://playing-bucket-nix-cache-test" \
#build \
#--keep-failed \
#--max-jobs 0 \
#--no-link \
#--no-show-trace \
#--print-build-logs \
#--print-out-paths \
#github:PedroRegisPOAR/.github/c6ca5765957381ac7fa55b50462f62441ebee989#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxDocker.config.system.build.vm

nix \
run \
github:PedroRegisPOAR/.github/c6ca5765957381ac7fa55b50462f62441ebee989#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxDocker.config.system.build.vm \
< /dev/null &


while ! ssh -i id_ed25519 -o ConnectTimeout=1 -o StrictHostKeyChecking=no nixuser@localhost -p "$HOST_MAPPED_PORT" <<<'nix flake metadata nixpkgs'; do \
  echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done \
&& ssh-keygen -R '[localhost]:'"$HOST_MAPPED_PORT"; \
ssh \
-i id_ed25519 \
-X \
-o ConnectTimeout=1 \
-o StrictHostKeyChecking=no \
nixuser@localhost \
-p "$HOST_MAPPED_PORT"

#<<COMMANDS
#id
#COMMANDS
#"$REMOVE_DISK" && rm -fv nixos.qcow2 id_ed25519
```


```bash
export DOCKER_HOST=ssh://nixuser@localhost:10022

docker run -it --rm docker.io/library/alpine sh -c 'cat /etc/os-*release'
```
Refs.:
- https://dev.to/jillesvangurp/docker-over-qemu-on-a-mac-1ajp


```bash
ssh -L 8000:localhost:8000 -p 10022 nixuser@localhost
```

```bash
nix run nixpkgs#python3 -- -m http.server 8000
```

In the host (client machine):
```bash
test $(curl -s -w '%{http_code}\n' localhost:8000 -o /dev/null) -eq 200 || echo 'Error'
```




#### aarch64-linux


```bash
nix \
build \
--max-jobs auto \
--no-link \
--no-show-trace \
--print-build-logs \
github:PedroRegisPOAR/.github/991bde1c67c86bc382601c01b2cb7dd6754c953e#nixosConfigurations.x86_64-linux.nixosBuildVMAarch64Linux.config.system.build.vm
```



```bash
time \
nix \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters "s3://playing-bucket-nix-cache-test" \
build \
--keep-failed \
--max-jobs 0 \
--no-link \
--no-show-trace \
--print-build-logs \
--print-out-paths \
--system aarch64-linux \
github:PedroRegisPOAR/.github/991bde1c67c86bc382601c01b2cb7dd6754c953e#nixosConfigurations.x86_64-linux.nixosBuildVMAarch64Linux.config.system.build.vm
```


```bash
mkdir -pv ~/sandbox/sandbox && cd $_

export HOST_MAPPED_PORT=10022
export REMOVE_DISK=true
export QEMU_NET_OPTS='hostfwd=tcp::10022-:10022,hostfwd=tcp:127.0.0.1:8000-:8000'
export QEMU_OPTS='-nographic'
export SHARED_DIR="$(pwd)"

"$REMOVE_DISK" && rm -fv nixos.qcow2
# nc 1>/dev/null 2>/dev/null || nix profile install nixpkgs#netcat
# nc -v -4 localhost "$HOST_MAPPED_PORT" -w 1 -z && echo 'There is something already using the port:'"$HOST_MAPPED_PORT"

# sudo lsof -t -i tcp:10022 -s tcp:listen
# sudo lsof -t -i tcp:10022 -s tcp:listen | sudo xargs --no-run-if-empty kill

cat << 'EOF' >> id_ed25519
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCsoS8eR1Ot8ySeS8eI/jUwvzkGe1npaHPMvjp+Ou5JcgAAAIjoIwah6CMG
oQAAAAtzc2gtZWQyNTUxOQAAACCsoS8eR1Ot8ySeS8eI/jUwvzkGe1npaHPMvjp+Ou5Jcg
AAAEAbL0Z61S8giktfR53dZ2fztctV/0vML24doU0BMGLRZqyhLx5HU63zJJ5Lx4j+NTC/
OQZ7Weloc8y+On467klyAAAAAAECAwQF
-----END OPENSSH PRIVATE KEY-----
EOF

chmod -v 0600 id_ed25519




nix \
run \
github:PedroRegisPOAR/.github/991bde1c67c86bc382601c01b2cb7dd6754c953e#nixosConfigurations.x86_64-linux.nixosBuildVMAarch64Linux.config.system.build.vm \
< /dev/null &


while ! ssh -i id_ed25519 -o ConnectTimeout=1 -o StrictHostKeyChecking=no nixuser@localhost -p 10022 <<<'nix flake metadata nixpkgs'; do \
  echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done \
&& ssh-keygen -R '[localhost]:10022'; \
ssh \
-i id_ed25519 \
-X \
-o StrictHostKeyChecking=no \
nixuser@localhost \
-p 10022

#<<COMMANDS
#id
#COMMANDS
#"$REMOVE_DISK" && rm -fv nixos.qcow2 id_ed25519
```


```bash
PID=?
tr '\0' '\n' < /proc/${PID}/cmdline
strace -f -T -y -e trace=file
```

