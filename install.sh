#!/usr/bin/env bash

get_seperator() {
    echo "==============================================="
}

echo "Running ./install.sh..."
get_seperator
echo "*** Installing dotfiles..."
get_seperator

echo "*** Checking if \$HOME exists..."
if [ -z $HOME ]; then
    echo "*** You got no \$HOME. :(";
    exit 1;
else
    echo "*** You got a \$HOME! \\o/"
fi

DOTFILES=$HOME/.dotfiles
DOTFILES_BACKUP=$HOME/dotfiles_backup

echo "*** Copy existing dotfiles to backup location => ~/dotfiles_backup..."
mkdir -p $DOTFILES_BACKUP
cp "$HOME/.vimrc" $DOTFILES_BACKUP
cp "$HOME/.zshrc" $DOTFILES_BACKUP

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
echo "*** Vundle downloaded! \\o/"

echo "*** Installing plugins listed in ~/.vimrc with Vundle..."
vim +PluginInstall +qall
echo "*** Vim plugins was installed! \\o/"

get_seperator
echo "*** Installation done!!! \\o/\\o/\\o/"
get_seperator


