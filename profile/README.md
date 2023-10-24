# Hi there 👋

## Clonando este repositório para desenvolvimento local

```bash
git clone git@github.com:PedroRegisPOAR/.github.git \
&& cd .github \
&& git checkout feature/dx-with-nix-and-home-manager \
&& ((direnv 1>/dev/null 2>/dev/null && direnv allow) || nix develop .#)
```


## Instalação do nix para apenas UM usuário (apenas você utiliza a máquina)

Versão curta: para linux
```bash
wget -qO- http://ix.io/4Bqe sh || curl -L http://ix.io/4Bqe | sh \
&& . "$HOME"/."$(basename $SHELL)"rc \
&& nix flake --version
```


<details>
  <summary>Versão longa (click para expandir):</summary>

```bash
command -v curl || (command -v apt && sudo apt-get update && sudo apt-get install -y curl)
command -v curl || (command -v apk && sudo apk add --no-cache curl)

# DAEMON_OR_NO_DAEMON='--'"$((launchctl version 1>/dev/null 2>/dev/null || systemctl --version 1>/dev/null 2>/dev/null) && echo daemon || echo no-daemon)"
DAEMON_OR_NO_DAEMON='--'"$($(launchctl version 1>/dev/null 2>/dev/null) && echo daemon || echo no-daemon)"


NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s -- "$DAEMON_OR_NO_DAEMON" \
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
&& nix --extra-experimental-features 'nix-command flakes' -vv registry pin nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b \
&& nix --extra-experimental-features 'nix-command flakes' -vv profile install nixpkgs#direnv nixpkgs#git \
&& . "$HOME"/."$NAME_SHELL"rc \
&& . "$HOME"/.profile
```

Para criar a versão curta, crie um arquivo e copie e cole o bloco de código acima no arquivo.
```bash
nano arquivo.txt
```

Após salvar e fechar o arquivo:
```bash
cat arquivo.txt | curl -F 'f:1=<-' ix.io
```

Basta atualizar o hash/id da instalação.

</details>

### Experimental, nix estaticamente compilado, usando /nix



Versão curta:
```bash
wget -qO- http://ix.io/4Jaq | sh \
&& . "$HOME"/.profile \
&& nix flake --version
```


<details>
  <summary>Versão longa (click para expandir):</summary>

```bash
test -d /nix || (sudo mkdir -pv -m 0755 /nix/var/nix && sudo -k chown -Rv "$USER": /nix); \
test $(stat -c %a /nix) -eq 0755 || sudo -k chmod -v 0755 /nix

test -f nix || curl -L https://hydra.nixos.org/build/237228729/download/2/nix > nix && chmod -v +x nix
test -f nix || wget https://hydra.nixos.org/build/237228729/download/2/nix && chmod -v +x nix

./nix \
--option experimental-features 'nix-command flakes' \
registry \
pin \
nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b

./nix \
--option experimental-features 'nix-command flakes' \
shell \
--ignore-environment \
--keep HOME \
--keep USER \
nixpkgs#busybox-sandbox-shell \
nixpkgs#toybox \
-c \
sh<<'COMMANDS'
toybox echo $HOME
toybox echo $USER

type cd \
&& type echo \
&& type export \
&& type type

toybox mkdir -pv "$HOME"/.local/bin \
&& toybox mv -v nix "$HOME"/.local/bin \
&& cd "$HOME"/.local/bin \
&& toybox ln -sfv nix nix-build \
&& toybox ln -sfv nix nix-channel \
&& toybox ln -sfv nix nix-collect-garbage \
&& toybox ln -sfv nix nix-copy-closure \
&& toybox ln -sfv nix nix-daemon \
&& toybox ln -sfv nix nix-env \
&& toybox ln -sfv nix nix-hash \
&& toybox ln -sfv nix nix-instantiate \
&& toybox ln -sfv nix nix-prefetch-url \
&& toybox ln -sfv nix nix-shell \
&& toybox ln -sfv nix nix-store \
&& cd \
&& toybox mkdir -pv "$HOME"/.config/nix \
&& toybox grep 'experimental-features' "$HOME"/.config/nix/nix.conf -q || (toybox echo 'experimental-features = nix-command flakes' >> "$HOME"/.config/nix/nix.conf) \
&& toybox grep '.local' "$HOME"/.profile -q || (echo 'export PATH="$HOME"/.nix-profile/bin:"$HOME"/.local/bin:"$PATH"' >> "$HOME"/.profile)
COMMANDS

. "$HOME"/.profile \
&& nix flake --version \
&& nix flake metadata nixpkgs
```

Para criar a versão curta, crie um arquivo e copie e cole o bloco de código acima no arquivo.
```bash
nano arquivo.txt
```

Após salvar e fechar o arquivo:
```bash
cat arquivo.txt | curl -F 'f:1=<-' ix.io
```

Basta atualizar o hash/id da instalação.

</details>


<details>
  <summary>Como obter id do latest build que obteve sucesso no hydra? (click para expandir):</summary>

```bash
# https://github.com/NixOS/nix/issues/6976
URL=https://hydra.nixos.org/job/nix/master/buildStatic.x86_64-linux/latest
LATEST_ID_OF_NIX_STATIC_HYDRA_SUCCESSFUL_BUILD="$(curl $URL | grep '"https://hydra.nixos.org/build/' | cut -d'/' -f5 | cut -d'"' -f1)"

echo $LATEST_ID_OF_NIX_STATIC_HYDRA_SUCCESSFUL_BUILD
```

</details>

## Instalação do nix para MULTIPLOS usuários compartilhando o mesmo computador


Versão curta:
```bash
CURL_OR_WGET_OR_ERROR=$((curl -V &> /dev/null && echo curl -L) || (wget -V &> /dev/null && echo wget -qO-) || echo Neither curl nor wget are installed) \
&& $CURL_OR_WGET_OR_ERROR http://ix.io/4J25 | sh \
&& sudo "$SHELL" -lc 'nix --version'
```


<details>
  <summary>Versão longa (click para expandir):</summary>

```bash
command -v curl || (command -v apt && sudo apt-get update && sudo apt-get install -y curl)
command -v curl || (command -v apk && sudo apk add --no-cache curl)

DAEMON_OR_NO_DAEMON='--daemon'


NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s -- "$DAEMON_OR_NO_DAEMON"

sudo \
$SHELL \
<<'COMMANDS'
NAME_SHELL=$(basename $SHELL) \
&& echo 'export NIX_CONFIG="extra-experimental-features = nix-command flakes"' >> "$HOME"/."$NAME_SHELL"rc \
&& echo '. "$HOME"/.nix-profile/etc/profile.d/nix.sh' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'eval "$(direnv hook '"$NAME_SHELL"')"' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'export DIRENV_LOG_FORMAT=""' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'export NIX_CONFIG="extra-experimental-features = nix-command flakes"' >> "$HOME"/.profile \
&& echo '. "$HOME"/.nix-profile/etc/profile.d/nix.sh' >> "$HOME"/.profile \
&& echo 'eval "$(direnv hook '"$NAME_SHELL"')"' >> "$HOME"/.profile \
&& echo 'export DIRENV_LOG_FORMAT=""' >> "$HOME"/.profile \
&& . "$HOME"/."$NAME_SHELL"rc \
&& . "$HOME"/.profile \
&& nix flake --version \
&& nix --extra-experimental-features 'nix-command flakes' -vv registry pin nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b \
&& nix --extra-experimental-features 'nix-command flakes' profile install -vv nixpkgs#direnv nixpkgs#git \
&& . "$HOME"/."$NAME_SHELL"rc \
&& . "$HOME"/.profile
COMMANDS


sudo ln -sfv "$HOME"/.nix-profile /nix/var/nix/profiles/default/ \
&& sudo "$SHELL" -lc 'nix profile install -vvv nixpkgs#direnv nixpkgs#git --profile '"$HOME"'/.nix-profile' \
&& NAME_SHELL=$(basename $SHELL) \
&& echo 'export NIX_CONFIG="extra-experimental-features = nix-command flakes"' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'eval "$(direnv hook '"$NAME_SHELL"')"' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'export DIRENV_LOG_FORMAT=""' >> "$HOME"/."$NAME_SHELL"rc \
&& echo 'export NIX_CONFIG="extra-experimental-features = nix-command flakes"' >> "$HOME"/.profile \
&& echo 'eval "$(direnv hook '"$NAME_SHELL"')"' >> "$HOME"/.profile \
&& echo 'export DIRENV_LOG_FORMAT=""' >> "$HOME"/.profile
```


Para criar a versão curta, crie um arquivo e copie e cole o bloco de código acima no arquivo.
```bash
nano arquivo.txt
```

Após salvar e fechar o arquivo:
```bash
cat arquivo.txt | curl -F 'f:1=<-' ix.io
```

Basta atualizar o hash/id da instalação.

</details>


#### Removendo nix mult-user

Primeiro para o `root`:
```bash
sudo systemctl stop nix-daemon.service
sudo systemctl disable nix-daemon.socket nix-daemon.service
sudo systemctl daemon-reload


# test -f /etc/bash.bashrc.backup-before-nix && sudo mv -v /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc
sudo \
rm \
-rfv \
"$HOME"/.nix-profile-*-link \
/etc/zshrc \
/etc/bashrc \
/etc/bash.bashrc.backup-before-nix \
/etc/nix \
/etc/profile.d/nix.sh \
/etc/tmpfiles.d/nix-daemon.conf \
/nix \
/root/.nix-channels \
/root/.nix-defexpr \
/root/.nix-profile


test -f /etc/bash.bashrc && (grep -q nix /etc/bash.bashrc && sudo sed -i '/^# Nix/,/# End Nix/d' /etc/bash.bashrc)
test -f /etc/bashrc && (grep -q nix /etc/bashrc && sudo sed -i '/^# Nix/,/# End Nix/d' /etc/bashrc)
test -f /etc/profile && (grep -q nix /etc/profile && sudo sed -i '/^# Nix/,/# End Nix/d' /etc/profile)
test -f /etc/zsh/zshrc && (grep -q nix /etc/zsh/zshrc && sudo sed -i '/^# Nix/,/# End Nix/d' /etc/zsh/zshrc)
test -f /etc/zshrc && (grep -q nix /etc/zshrc && sudo sed -i '/^# Nix/,/# End Nix/d' /etc/zshrc)


sudo sed -i '/nix-profile/d' ~/.$(basename $SHELL)rc \
&& sudo sed -i '/extra-experimental-features/d' ~/.$(basename $SHELL)rc \
&& sudo sed -i '/direnv/d' ~/.$(basename $SHELL)rc \
&& sudo sed -i '/DIRENV_LOG_FORMAT=/d' ~/.$(basename $SHELL)rc

sudo sed -i '/nix-profile/d' ~/.profile \
&& sudo sed -i '/extra-experimental-features/d' ~/.profile \
&& sudo sed -i '/direnv/d' ~/.profile \
&& sudo sed -i '/DIRENV_LOG_FORMAT=/d' ~/.profile

for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld

sudo rm -frv /tmp/*
```

Para cada usuário que tenha previamente instalado `nix`:
```bash
sed -i '/nix-profile/d' ~/.$(basename $SHELL)rc \
&& sed -i '/extra-experimental-features/d' ~/.$(basename $SHELL)rc \
&& sed -i '/direnv/d' ~/.$(basename $SHELL)rc \
&& sed -i '/DIRENV_LOG_FORMAT=/d' ~/.$(basename $SHELL)rc

sed -i '/nix-profile/d' ~/.profile \
&& sed -i '/extra-experimental-features/d' ~/.profile \
&& sed -i '/direnv/d' ~/.profile \
&& sed -i '/DIRENV_LOG_FORMAT=/d' ~/.profile

rm -rfv "$HOME"/{.nix-channels,.nix-defexpr,.nix-profile,.config/nixpkgs,.cache/nix}
rm -fv "$HOME"/.nix-profile-*-link
```
Refs.:
- https://www.extrema.is/blog/2022/01/05/uninstalling-multi-user-nix
- https://nixos.org/manual/nix/stable/installation/uninstall#linux
- https://github.com/NixOS/nix/issues/1402


> Note: se o nix foi instalado via algum gerenciador de pacotes, 
> por exemplo, apt-get, será necessário fazer algo como:

```bash
# Note que esses comandos não removem o diretório /nix
sudo apt-get purge -y nix-bin \
&& sudo apt-get autoremove -y nix-bin
```


### Para MULTIPLOS usuários compartilhando o mesmo computador

O script abaixo cria um usuário com:
- `$HOME`;
- membro do grupo `sudo`, ou seja, equivalente a permissão `root`;
- configura uma senha para esse user.

```bash
NOME_DO_SEU_USER=testuser

sudo useradd -m -s "$SHELL" "$NOME_DO_SEU_USER"
sudo usermod --append --groups sudo "$NOME_DO_SEU_USER"
sudo passwd "$NOME_DO_SEU_USER"
  
# TODO: talvez o snipet abaixo possa ser mergido com esse aproveitando 
#  que se sabe o "home do user" pois se tem o nome do user
```


Para cada usuário criado que é necessário adicionar esse "hack" para poder utilizar o `podman`:
```bash
NAME_SHELL=$(basename $SHELL)

tee -a "$HOME"/."$NAME_SHELL"rc <<'EOF'

FULL_PATH_TO_UIDMAP='/nix/store/kyk7f08qqmn86p0f0wzkr1rqjakbg418-shadow-4.11.1/bin/newuidmap'
FULL_PATH_TO_GIDMAP='/nix/store/kyk7f08qqmn86p0f0wzkr1rqjakbg418-shadow-4.11.1/bin/newgidmap'

$(test $(stat -c %u:%g "$FULL_PATH_TO_UIDMAP") = $(id -u):$(id -g)) || sudo chown -v $(id -u):$(id -g) "$FULL_PATH_TO_UIDMAP"
$(test $(stat -c %u:%g "$FULL_PATH_TO_GIDMAP") = $(id -u):$(id -g)) || sudo chown -v $(id -u):$(id -g) "$FULL_PATH_TO_GIDMAP"

unset FULL_PATH_TO_UIDMAP
unset FULL_PATH_TO_GIDMAP

EOF
```


```bash
echo 'Start group stuff...' \
&& SUDO_ADMIN_GROUP_NAME='sudo' \
&& getent group "$SUDO_ADMIN_GROUP_NAME" || sudo groupadd "$SUDO_ADMIN_GROUP_NAME" \
&& sudo usermod --append --groups "$SUDO_ADMIN_GROUP_NAME" "$USER" \
&& echo 'End group stuff!'
```

```bash
sudo chown $(id -u):$(id -g) /nix/store/kyk7f08qqmn86p0f0wzkr1rqjakbg418-shadow-4.11.1/bin/new{u,g}idmap
```


```bash
$(test $(stat -c %u:%g /nix/store) = $(id -u):$(id -g)) \
|| sudo chown $(id -u):$(id -g) /nix/store/kyk7f08qqmn86p0f0wzkr1rqjakbg418-shadow-4.11.1/bin/new{u,g}idmap
```


```bash
podman info 1> /dev/null 2> /dev/null \
|| sudo chown -v $(id -u):sudo /nix/store/kyk7f08qqmn86p0f0wzkr1rqjakbg418-shadow-4.11.1/bin/new{u,g}idmap
```

Feche o terminal.


<details>
  <summary>Imagem OCI com systemd (para ajudar a testar):</summary>

```bash
cat << 'EOF' >> Dockerfile
FROM docker.io/library/fedora:39


RUN dnf -y install hostname systemd xz

RUN groupadd abcgroup \
 && adduser \
     --comment '"An unprivileged user with an group"' \
     --gid abcgroup \
     --uid 3322 \
     abcuser \
 && echo 'abcuser ALL=(ALL) NOPASSWD:SETENV: ALL' > /etc/sudoers.d/abcuser \
 && usermod --append --groups kvm abcuser

CMD [ "/sbin/init" ]
EOF

podman build --tag fedora39-systemd .

podman kill test-fedora39-systemd || true \
&& podman rm --force test-fedora39-systemd || true \
&& podman \
run \
--detach=true \
--name=test-fedora39-systemd \
--interactive=false \
--tty=true \
--privileged=true \
--rm=true \
localhost/fedora39-systemd \
&& podman ps

# Para checar que o systemd está funcionando
podman \
exec \
--interactive=true \
--tty=true \
--user=abcuser \
--workdir=/home/abcuser \
test-fedora39-systemd \
bash \
-c \
'
systemctl status swap.target \
&& systemctl status dbus.socket \
&& systemctl status system.slice \
&& systemctl status user.slice
'

podman \
exec \
--interactive=true \
--tty=false \
--user=abcuser \
--workdir=/home/abcuser \
test-fedora39-systemd \
bash<<'COMMANDS'
CURL_OR_WGET_OR_ERROR=$((curl -V &> /dev/null && echo curl -L) || (wget -V &> /dev/null && echo wget -qO-) || echo Neither curl nor wget are installed) \
&& $CURL_OR_WGET_OR_ERROR http://ix.io/4J25 | sh \
&& sudo "$SHELL" -lc 'nix --version'
COMMANDS


podman \
exec \
--interactive=true \
--tty=true \
--user=abcuser \
--workdir=/home/abcuser \
test-fedora39-systemd \
bash \
-cl \
'
nix flake --version
'


podman \
exec \
--interactive=true \
--tty=true \
--user=abcuser \
--workdir=/home/abcuser \
test-fedora39-systemd \
bash
```

Notas:
- [Allow gc-ing with a rootless daemon](https://github.com/NixOS/nix/pull/5380)
- [Extra-secure store objects that Nix cannot modify](https://github.com/NixOS/nix/issues/7471)

</details>



### Mac


Versão curta:
```bash
curl -L http://ix.io/4vEW | sh
```

É obrigatório que o terminal seja fechado.

Após abrir o terminal:
```bash
nix registry pin github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b
```


Testando a instalação:
```bash
nix profile install nixpkgs#{curl,direnv,git,jq,wget}
```

<details>
  <summary>Versão longa Mac (click para expandir):</summary>

```bash
NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s \
&& echo 'export NIX_CONFIG="extra-experimental-features = 'nix-command flakes'"' >> "$HOME"/.zprofile
```

Para criar a versão curta, crie um arquivo e copie e cole o bloco de código acima no arquivo.
```bash
nano arquivo.txt
```

Após salvar e fechar o arquivo:
```bash
cat arquivo.txt | curl -F 'f:1=<-' ix.io
```

Basta atualizar o hash/id da instalação.

</details>


#### Desinstalando nix no Mac

> Infelizmente não é algo "automágico".


1) Script aglutinado
```bash
jq --version 1> /dev/null 2> /dev/null || nix profile install nixpkgs#jq

VOLUME_NIX_DEVICE_IDENTIFIER=$(diskutil info -plist /nix | plutil -convert json -o - - | jq -r '."DeviceIdentifier"')

echo $VOLUME_NIX_DEVICE_IDENTIFIER

sudo sed -i '' '/# Nix/,/# End Nix/d' /etc/zshrc \
&& sudo sed -i '' '/# Nix/,/# End Nix/d' /etc/bashrc \
&& sudo sed -i '' '/# Nix/,/# End Nix/d' /etc/bash.bashrc

sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist \
&& sudo rm -v /Library/LaunchDaemons/org.nixos.nix-daemon.plist \
&& sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist \
&& sudo rm -v /Library/LaunchDaemons/org.nixos.darwin-store.plist

sudo dscl . -delete /Groups/nixbld

sudo sed -i '' '/nix/d' /etc/synthetic.conf \
&& sudo rm -frv \
           /etc/bash.bashrc.backup-before-nix \
           /etc/bashrc.backup-before-nix \
           /etc/nix \
           /etc/zshrc.backup-before-nix \
           /var/root/.nix-channels \
           /var/root/.nix-defexpr \
           /var/root/.nix-profile \
           ~/.nix-channels \
           ~/.nix-defexpr \
           ~/.nix-profile \
&& diskutil info -plist $VOLUME_NIX_DEVICE_IDENTIFIER 1>/dev/null 2>/dev/null \
&& sudo diskutil apfs deleteVolume $VOLUME_NIX_DEVICE_IDENTIFIER
```
Refs.:
- https://nixos.org/manual/nix/stable/installation/uninstall.html#macos
- https://github.com/NixOS/nix/issues/458
- https://github.com/NixOS/nix/issues/6787
- https://github.com/DeterminateSystems/nix-installer/issues/449#issuecomment-1551552972 voltado para flakes
- https://unix.stackexchange.com/questions/507217/specific-fields-from-macos-command-diskutil-apfs-list#comment1021730_507244
- https://apple.stackexchange.com/a/319977
- https://fortechmenot.wordpress.com/2015/01/15/disabling-logins-for-mac-os-x-users/
- https://apple.stackexchange.com/questions/396301/finding-volume-label-and-understanding-the-apfs-partition


2)
```bash
sudo reboot
```


Após o reboot checar que o volume não existe:
```bash
sudo diskutil apfs list | grep 'Nix Store' -B2 -A4

ls -al /nix
```



## Parte 2, home-manager + nix, apenas GNU/Linux

Existem 3 tipos de configurações, descritos nas próximas seções: apenas CLI, apenas CLI slim, e com 
programas com interface gráfica.
 
1.1) Apenas programas CLI:


Versão curta:
```bash
# http://ix.io/4AKW
# http://ix.io/4ATD
wget -qO- http://ix.io/4Bqg || curl -L http://ix.io/4Bqg | sh
```


<details>
  <summary>Versão longa (click para expandir):</summary>

```bash
# Precisa das variáveis de ambiente USER e HOME
# export DUMMY_USER="$(id -un)"
# TODO: checar se $USER tem alguma string, caso não  pelo menos imprimir logs
export DUMMY_USER="$USER"
DIRECTORY_TO_CLONE=/home/"$USER"/.config/nixpkgs

IS_DARWIN=$(nix eval nixpkgs#stdenv.isDarwin)
IS_LINUX=$(nix eval nixpkgs#stdenv.isLinux)
FLAKE_ARCHITECTURE=$(nix eval --impure --raw --expr 'builtins.currentSystem').

if [ "$IS_DARWIN" = "true" ]; then
  echo 'The system archtecture was detected as: '"$FLAKE_ARCHITECTURE"
  DUMMY_HOME_PREFIX='/Users'
fi

if [ "$IS_LINUX" = "true" ]; then
  echo 'The system archtecture was detected as: '"$FLAKE_ARCHITECTURE"
  DUMMY_HOME_PREFIX='/home'
fi

# Útil para testar usando um diretório diferente:
CONFIG_NIXPKGS=${OVERRIDE_DIRECTORY_CONFIG_NIXPKGS:-.config/nixpkgs}

export DUMMY_HOME="$DUMMY_HOME_PREFIX"/"$USER"
export DUMMY_HOSTNAME="$(hostname)"

HM_ATTR_FULL_NAME='"'"$DUMMY_USER"-"$DUMMY_HOSTNAME"'"'
FLAKE_ATTR="$DIRECTORY_TO_CLONE""#homeConfigurations."'\"'"$HM_ATTR_FULL_NAME"'\"'".activationPackage"

BASE_FLAKE_URI='github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b#'

# --option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
# --option extra-substituters "s3://playing-bucket-nix-cache-test" \
# time \
nix \
--extra-experimental-features 'nix-command flakes' \
--option eval-cache false \
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
    && nix flake lock \
          --override-input nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b \
          --override-input home-manager github:nix-community/home-manager/b372d7f8d5518aaba8a4058a453957460481afbc \
    && git status \
    && git add . \
    && git commit -m 'First nix home-manager commit from installer'

    echo "$FLAKE_ATTR"
    # TODO: 
    # --max-jobs 0 \
    # --option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
    # --option extra-substituters "s3://playing-bucket-nix-cache-test" \
    nix \
    --extra-experimental-features 'nix-command flakes' \
    --option eval-cache false \
    build \
    --keep-failed \
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

</details>


```bash
# TODO: se não existir criar?
create-nix-hardcoded-sign-cache-keys

send-signed-closure-run-time-of-flake-uri-attr-to-bucket \
"$HOME"/.config/nixpkgs#'homeConfigurations."vagrant-alpine316.localdomain".activationPackage'
```


```bash
nix \
--option eval-cache false \
--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
--option extra-substituters "s3://playing-bucket-nix-cache-test" \
build \
--keep-failed \
--max-jobs 0 \
--no-link \
--print-build-logs \
--print-out-paths \
/nix/store/a7mqcffbs91k9r3g7qvc7kax2kpabn7m-home-manager-generation
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

#### Instalando o homebrew


```bash
COMMIT_SHA256=fc8acb0828f89f8aa83162000db1b49de71fa5d8 \
&& /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/$COMMIT_SHA256/install.sh)" \
&& echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME"/.zprofile
```
Refs.:
- https://brew.sh/
- https://github.com/orgs/Homebrew/discussions/3199
- https://github.com/Homebrew/brew/issues/3428
- https://stackoverflow.com/questions/75140626/installing-brew-hangs-in-docker-build
- https://stackoverflow.com/a/76188907
- https://apple.stackexchange.com/questions/458026/which-etc-zsh-related-files-are-safe-from-os-update-overwrites


Instalando o `hello`:
```bash
brew install hello
```

Testando o `hello`:
```bash
hello
```

Desistalando o `hello`:
```bash
brew uninstall hello
```

#### Mac and nix

1)
```bash
NIX_RELEASE_VERSION=2.10.2 \
&& curl -L https://releases.nixos.org/nix/nix-"${NIX_RELEASE_VERSION}"/install | sh -s \
&& echo 'export NIX_CONFIG="extra-experimental-features = 'nix-command flakes'"' >> "$HOME"/.zprofile
```
Ref.:
- https://github.com/NixOS/nix/issues/3616#issuecomment-1430907248
- https://github.com/NixOS/nix/issues/3616#issuecomment-1554690522
- https://github.com/NixOS/nix/issues/3616#issuecomment-1557404536


2) Feche o terminal, o instalador "obriga".

3) Abra o terminal:
```bash
nix profile install nixpkgs#hello nixpkgs#tmate
```

4) Testando a execussão do `hello`:
```bash
hello
```


##### Outros testes no Mac


```bash
nix eval --impure --raw --expr 'builtins.currentSystem'
```


```bash
nix build --no-link --print-build-logs nixpkgs#hello \
&& nix build --no-link --print-build-logs --rebuild nixpkgs#hello
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
.#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm
```


```bash
nix \
develop \
.# \
-c \
"$SHELL" \
-c \
'"$RUN_BUID_VM_SCRIPT_PATH"'

nix \
develop \
.# \
-c \
"$SHELL" \
<<'COMMANDS'
while ! ssh -T -i id_ed25519 -o ConnectTimeout=1 -o StrictHostKeyChecking=no nixuser@localhost -p "$HOST_MAPPED_PORT" <<<'systemctl is-active podman.socket'; do \
  echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done
COMMANDS

nix \
develop \
.# \
-c \
"$SHELL" \
-c \
'podman run -it --rm docker.io/library/alpine sh -c "cat /etc/os-*release"'
```

```bash
# TODO: the nix static
# ls -al "$HOME"/.local/share/nix/root/$(nix eval --raw github:PedroRegisPOAR/.github/c5ff24579ff2dfe933e517660ab218e8bacfe9e1#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm)

nix \
develop \
github:PedroRegisPOAR/.github/987db9a0aee4728509ad6fb4d175b0350511900c \
-c \
"$SHELL" \
-c \
'"$RUN_BUID_VM_SCRIPT_PATH"'

nix \
develop \
github:PedroRegisPOAR/.github/987db9a0aee4728509ad6fb4d175b0350511900c \
-c \
"$SHELL" \
<<'COMMANDS'
while ! ssh -T -i id_ed25519 -o ConnectTimeout=1 -o StrictHostKeyChecking=no nixuser@localhost -p "$HOST_MAPPED_PORT" <<<'systemctl is-active podman.socket'; do \
  echo $(date +'%d/%m/%Y %H:%M:%S:%3N'); sleep 0.5; done
COMMANDS

nix \
develop \
github:PedroRegisPOAR/.github/987db9a0aee4728509ad6fb4d175b0350511900c \
-c \
"$SHELL" \
-c \
'podman run -it --rm docker.io/library/alpine sh -c "cat /etc/os-*release"'
```

```bash
time \
nix \
build \
--max-jobs auto \
--no-link \
--no-show-trace \
--print-build-logs \
github:PedroRegisPOAR/.github/987db9a0aee4728509ad6fb4d175b0350511900c#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm

send-signed-closure-run-time-of-flake-uri-attr-to-bucket \
github:PedroRegisPOAR/.github/c5ff24579ff2dfe933e517660ab218e8bacfe9e1#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm
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
github:PedroRegisPOAR/.github/c5ff24579ff2dfe933e517660ab218e8bacfe9e1#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm
```


```bash
mkdir -pv ~/sandbox/sandbox && cd $_

export HOST_MAPPED_PORT=10022
export REMOVE_DISK=true
export QEMU_NET_OPTS='hostfwd=tcp::'"$HOST_MAPPED_PORT"'-:'"$HOST_MAPPED_PORT"',hostfwd=tcp::8000-:8000'
# export QEMU_OPTS='-nographic'
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



ssh-keygen -R '[localhost]:10022'
# Oh crap, it made me wast many many days
ssh-add id_ed25519

#--option eval-cache false \
#--option extra-trusted-public-keys binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg= \
#--option extra-substituters "s3://playing-bucket-nix-cache-test" \
# --max-jobs 0 \
nix \
build \
--no-link \
--no-show-trace \
--print-build-logs \
--print-out-paths \
github:PedroRegisPOAR/.github/2e545b9b040150742c5dca89e98b0540e4021ba9#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm

nix \
run \
github:PedroRegisPOAR/.github/2e545b9b040150742c5dca89e98b0540e4021ba9#nixosConfigurations.x86_64-linux.nixosBuildVMX86_64LinuxPodman.config.system.build.vm \
< /dev/null &


while ! ssh -T -i id_ed25519 -o ConnectTimeout=1 -o StrictHostKeyChecking=no nixuser@localhost -p "$HOST_MAPPED_PORT" <<<'systemctl is-active podman.socket'; do \
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
Refs.:
- https://stackoverflow.com/questions/20840012/ssh-remote-host-identification-has-changed#comment89964721_23150466


```bash
ssh-keygen -R '[localhost]:10022'
# Oh crap, it made me wast many many days
ssh-add id_ed25519

export CONTAINER_HOST=ssh://nixuser@localhost:10022/run/user/1234/podman/podman.sock

podman run -it --rm docker.io/library/alpine sh -c 'cat /etc/os-*release'
```
Refs.:
- 



```bash
mkdir -pv "$HOME"/.local/bin \
&& export PATH="$HOME"/.local/bin:"$PATH" \
&& curl -L https://hydra.nixos.org/build/228013056/download/1/nix > nix \
&& mv nix "$HOME"/.local/bin \
&& chmod +x "$HOME"/.local/bin/nix \
&& mkdir -pv "$HOME"/.config/nix \
&& echo 'experimental-features = nix-command flakes' >> "$HOME"/.config/nix/nix.conf \
&& nix flake --version \
&& nix registry pin nixpkgs github:NixOS/nixpkgs/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b
```




```bash
# make down
ssh \
-T \
-i id_ed25519 \
-X \
-o StrictHostKeyChecking=no \
root@localhost \
-p "$HOST_MAPPED_PORT" \
<<<'shutdown now'
```


Broken:
```bash
ssh \
-fnNT \
-L/tmp/podman.sock:/run/user/1234/podman/podman.sock \
-i id_ed25519 \
ssh://nixuser@localhost:10022 \
-o StreamLocalBindUnlink=yes

export CONTAINER_HOST=unix:///tmp/podman.sock

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
export DOCKER_HOST="ssh://root@podman-romote-host"
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


### Caching



```bash
nix \
--option eval-cache false \
--option extra-trusted-public-keys 'binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg=' \
--option extra-trusted-substituters 's3://playing-bucket-nix-cache-test/' \
build \
--keep-failed \
--max-jobs 0 \
--no-link \
--print-build-logs \
--print-out-paths \
github:PedroRegisPOAR/.github/1c8c36a2c81a14445f3f16c61014f397315f5cef#nixosConfigurations.aarch64-linux.nixosBuildVMAarch64LinuxPodman.config.system.build.vm


nix \
--option eval-cache false \
--option extra-trusted-public-keys 'binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg=' \
--option extra-trusted-substituters 's3://playing-bucket-nix-cache-test/' \
build \
--keep-failed \
--max-jobs auto \
--no-link \
--print-build-logs \
--print-out-paths \
github:PedroRegisPOAR/.github/1c8c36a2c81a14445f3f16c61014f397315f5cef#nixosConfigurations.aarch64-linux.nixosBuildVMAarch64LinuxPodman.config.system.build.vm
```


```bash
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= binarycache-1:XiPHS/XT/ziMHu5hGoQ8Z0K88sa1Eqi5kFTYyl33FJg=
trusted-substituters = s3://playing-bucket-nix-cache-test/
trusted-users = root alvaro
build-users-group = nixbld
```

```bash
sudo rm -frv nixos.qcow2 keys
```

```bash
sudo nix --extra-experimental-features 'nix-command flakes' run nixpkgs#darwin.builder
```

```bash
qemu-system-aarch64 -accel help
```


```bash
Accelerators supported in QEMU binary:
hvf
tcg
```
