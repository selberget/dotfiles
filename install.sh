#!/usr/bin/env bash

get_seperator() {
    echo "=========================================================================="
}

backup_dotfile() {
    FILE=$1
    DIR=$2
    if [ -f "$HOME/$FILE" ] ; then
        echo "$FILE exists on the system: copying $FILE to ~/dotfiles_backup..."
        cp "$HOME/$FILE" $DIR
    else
        echo "$FILE does not exist on the system: no need to backup..."
    fi
}

remove_dotfile() {
    FILE=$1
    if [ -f "$FILE" ] || [ -d "$FILE" ] ; then
        echo "$FILE exists on the system: deleting $FILE..."
        rm -rf "$FILE"
    else
        echo "$FILE does not exist on the system: no need to delete.."
    fi
}

create_symlink() {
    FILE=$1
    LINK=$2
    echo "creating symlink from $FILE to $LINK..."
    ln -s "$FILE" "$LINK"
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
get_seperator
mkdir -p $DOTFILES_BACKUP
backup_dotfile ".vimrc" "$DOTFILES_BACKUP"
backup_dotfile ".zshrc" "$DOTFILES_BACKUP"
get_seperator

echo "*** Removing existing dotfiles..."
get_seperator
remove_dotfile "$HOME/.vim"
remove_dotfile "$HOME/.vimrc"
remove_dotfile "$HOME/.zshrc"
get_seperator

echo "*** Creating symlinks from ~/.dotfiles to ~/..."
get_seperator
create_symlink "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
get_seperator

# Installing Vim plugins with vundle.
echo "*** Downloading Vundle to ~/.vim/bundle/Vundle.vim..."
get_seperator
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
get_seperator

echo "*** Installing plugins listed in ~/.vimrc with Vundle..."
vim +PluginInstall +qall
echo "*** Vim plugins was installed! \\o/"

get_seperator
echo "*** Installation done!!! \\o/\\o/\\o/"
get_seperator


