#!/usr/bin/env bash

DOTFILES="$(pwd)"

ask_yes_or_no () {
    read -p "$1 ([y]es or [N]o - Default no)"
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}

_get_files_to_link() {
    find -H $HOME/.dotfiles -name '*.slink'
}

setup_symlinks() {
    echo "Creating symlinks"

    if [ ! -e "$HOME/.dotfiles" ]; then
        echo "Adding symlink to dotfiles at $HOME/.dotfiles"
        ln -s "$DOTFILES" ~/.dotfiles
    fi

    for file in $(_get_files_to_link) ; do
        target="$HOME/$(basename "$file" '.slink')"

        if [ -e "$target" ]; then
            echo "~$target already exists... Skipping."
        else
            echo "Creating symlink for $file"
            ln -s "$file" "$target"
        fi
    done
}

if [[ "yes" == $(ask_yes_or_no "Set up MacOS defaults and packages?") ]]; then
    ~/.dotfiles/.osx
    ~/.dotfiles/iterm2/defaults.sh
    install -m 755 ~/.dotfiles/osascripts/* /usr/local/bin
fi

if [[ "yes" == $(ask_yes_or_no "Set up dotfiles symlinks ?") ]]; then
    setup_symlinks
fi

if [[ "yes" == $(ask_yes_or_no "Set up Neo vim?") ]]; then
    mkdir -p ~/.config/nvim
    ln -s ~/.dotfiles/.nvim/init.vim.slink ~/.config/nvim/init.vim
fi

# https://www.rust-lang.org/learn/get-started
if [[ "yes" == $(ask_yes_or_no "Install RustUP?") ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
if [[ "yes" == $(ask_yes_or_no "Install Krew?") ]]; then
    (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
    )
    if [[ "yes" == $(ask_yes_or_no "Install Krew Plugins?") ]]; then
        export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
        kubectl krew install ctx
        kubectl krew install access-matrix
        kubectl krew install cert-manager
        kubectl krew install nginx-ingress
        kubectl krew install sniff
        kubectl krew install tail
        kubectl krew install who-can
    fi
fi
