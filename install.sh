#!/usr/bin/env bash

get_seperator() {
    echo "====================================="
}

echo "*** Installing dotfiles..."
get_serperator

echo "*** Checking if \$HOME exists..."
get_seperator
if [ -z $HOME ]; then
    echo "*** You got no \$HOME. :(";
    exit 1;
else
    echo "*** You got a \$HOME. \\o/"
fi
get_seperator

DOTFILES=$HOME/.dotfiles
DOTFILES_BACKUP=$HOME/dotfiles_backup

echo "*** Copy existing dotfiles to backup location => ~/dotfiles_backup..."
mkdir -p $DOTFILES
cp "$HOME/.vimrc" $DOTFILES
cp "$HOME/.zshrc" $DOTFILES

echo "*** Removing existing dotfiles..."
rm -rf \
    "$HOME/.vim" \
    "$HOME/.vimrc" \
    "$HOME/.zshrc"

echo "*** Creating symlinks from ~/.dotfiles to ~/..."
ln -s "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
ln -s "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# Installing Vim plugins with vundle.
echo "*** Downloading Vundle to ~/.vim/bundle/Vundle.vim..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo "*** Vundle downloaded \\o/"

echo "*** Installing plugins listed in ~/.vimrc with Vundle..."
vim +PluginInstall +qall
echo "*** Vim plugin was installed \\o/"

get_seperator
echo "*** Zeh dotfiles are installed on the system \\o/\\o/\\o/\\o/\\o/\\o/"


