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
