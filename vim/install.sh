#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

download_vundle() {
    local vundle_path="${HOME}/.vim/bundle/Vundle.vim"
    printf "Installing vundle to handle vim plugins...\n"
    if [ ! -d "$vundle_path" ] 
    then
        git clone --quiet https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        printf "  Download Vundle to %s\n" "${vundle_path}"
    else
       printf "  Vundle already installed\n"
    fi
}

install_vim_plugins() {
    printf "Installing plugins listed in ~/.vimrc with Vundle...\n"
    vi -E +PluginInstall +qall > /dev/null
    printf "  vim plugins installed\n"
}

main() {
    printf "Installing vim plugins...\n"
    download_vundle
    install_vim_plugins
}

main "$@"

