#!/usr/bin/env bash

# Sources
#http://bash3boilerplate.sh/
#https://github.com/bertvv/dotfiles/blob/master/.vim/templates/sh
#https://github.com/ralish/bash-script-template/blob/stable/script.sh


# [Settings]

# exit on error, append '|| true if you expect error
set -o errexit
# exit on error inside subshell or function
set -o errtrace
# abort on unbound variable
set -o nounset
# catch error if pipe fails
set -o pipefail

# [Variables]

readonly __script_name=$(basename "${0}")
readonly __script_dir=$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)

declare -Ar __dotfiles=(
    ["i3"]=".config/i3"
    ["rofi"]=".config/rofi"
    ["vim/.vimrc"]=".vimrc"
    ["tmux/.tmux.conf"]=".tmux.conf"
    ["zsh/.zprofile"]=".zprofile"
    ["zsh/.zshrc"]=".zshrc"
    ["xresources/.Xresources"]=".Xresources"
)

# [Help functions]

print_seperator() {
    local length=70
    for i in $(seq 1 "${length}"); do
        printf "\u2501"
    done
    printf "\n"
}

backup_dotfiles() {
    local dotfiles_backup_dir="${HOME}/dotfiles.bak"
   
    printf "Backing up old dotfiles...\n"

    print_seperator

    mkdir -p "${dotfiles_backup_dir}"

    for dotfile_path in "${__dotfiles[@]}"; do
        if [ -f "${HOME}/${dotfile_path}" ] ; then
            printf "Dotfile %s exists!\n" "${dotfile_path}"
            printf " \u21AA Copying %s to %s...\n" "${HOME}/${dotfile_path}" "${dotfiles_backup_dir}" 
            cp "${HOME}/${dotfile_path}" "${dotfiles_backup_dir}"
        elif [ -d "${HOME}/${dotfile_path}" ]; then
            printf "Dotfiles directory %s exists!\n" "${dotfile_path}"
            printf " \u21AA Copying %s to %s...\n" "${HOME}/${dotfile_path}" "${dotfiles_backup_dir}" 
            cp -r "${HOME}/${dotfile_path}" "${dotfiles_backup_dir}"
        else
            printf "%s doesn't exist...\n" "${dotfile_path}"
            printf " \u21AA No need to backup!\n"
        fi
    done

    print_seperator
}
    #FILE=$1
    #DIR=$2
    #if [ -f "$HOME/$FILE" ] ; then
        #echo "$FILE exists on the system: copying $FILE to ~/dotfiles_backup..."
        #cp "$HOME/$FILE" $DIR
    #else
        #echo "$FILE does not exist on the system: no need to backup..."
    #fi

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


main() {
    printf "Running %s...\n" "${__script_name}"
    printf "dir: %s\n" "${__script_dir}"
    backup_dotfiles

}

main "${@}"



#DOTFILES=$HOME/.dotfiles
#DOTFILES_BACKUP=$HOME/dotfiles_backup

#echo "*** Copy existing dotfiles to backup location => ~/dotfiles_backup..."
#get_seperator
#mkdir -p $DOTFILES_BACKUP
#backup_dotfile ".vimrc" "$DOTFILES_BACKUP"
#backup_dotfile ".zshrc" "$DOTFILES_BACKUP"
#backup_dotfile ".tmux.conf" "$DOTFILES_BACKUP"
#get_seperator

#echo "*** Removing existing dotfiles..."
#get_seperator
#remove_dotfile "$HOME/.vim"
#remove_dotfile "$HOME/.vimrc"
#remove_dotfile "$HOME/.zshrc"
#remove_dotfile "$HOME/.tmux.conf"
#get_seperator

#echo "*** Creating symlinks from ~/.dotfiles to ~/..."
#get_seperator
#create_symlink "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
#create_symlink "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
#create_symlink "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
#get_seperator

## Installing Vim plugins with vundle.
#echo "*** Downloading Vundle to ~/.vim/bundle/Vundle.vim..."
#get_seperator
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#get_seperator

#echo "*** Installing plugins listed in ~/.vimrc with Vundle..."
#vim +PluginInstall +qall
#echo "*** Vim plugins was installed! \\o/"

#get_seperator
#echo "*** Installation done!!! \\o/\\o/\\o/"
#get_seperator


