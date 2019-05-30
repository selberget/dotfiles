#!/usr/bin/env bash

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

# unicode symbols
readonly __head_action="\u226B"
readonly __add_action="+"
readonly __action_step="\u21AA"
readonly __action_completed="\u2713"
readonly __info_message="\u2022"
readonly __seperator="\u2501"

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
    local length=72
    for i in $(seq 1 "${length}"); do
        printf "${__seperator}"
    done
    printf "\n"
}

print_info() {
    print_seperator
    printf "${__head_action} Info\n"
    print_seperator
    printf "${__info_message} This is an installation script for installing my dotfiles on a system.\n"
    printf "${__info_message} The dotfiles will be stored in the directory which you're running\n"
    printf "  the script from (%s).\n" "${__script_dir}"
    printf "${__info_message} Symlinks are created where each dotfile is usually stored.\n"
    printf "${__info_message} Existing dotfiles will, if they exist, be backed up to %s.\n"
    printf "${__info_message} After the dotfiles are installed on the system, Vundle will be used \n"
    printf "  to install Vim plugins listed in .vimrc.\n"
    print_seperator
}

input_prompt() {
    while true; do
        read -p "Do you still wish to run the script? " response
        case "${response}" in
            [Yy]* ) printf "Proceeding with the installation! \\o/\n"; break;;
            [Nn]* ) printf "bye :(\n"; exit;;
        esac
    done
    print_seperator
}

backup_dotfile() {
    local dotfile_path="${1}"
    local dotfiles_backup_dir="${HOME}/dotfiles.bak"

    printf "  ${__action_step} Backing up %s\n" $(basename "${dotfile_path}")

    if [ -f "${dotfile_path}" ] || [ -d "${dotfile_path}" ]; then
        printf "    ${__action_step} %s exists on the system\n" $(basename "${dotfile_path}")
        printf "      ${__action_step} Copying %s to %s\n" $(basename "${dotfile_path}") "${dotfiles_backup_dir}" 
        cp -r "${dotfile_path}" "${dotfiles_backup_dir}"
        printf "      ${__action_step} Removing old %s from the system\n" $(basename "${dotfile_path}")
        rm -rf "${dotfile_path}"
    else
        printf "    ${__action_step} %s doesn't exist\n" $(basename "${dotfile_path}")
        printf "      ${__action_step} No need to backup\n"
    fi
}

create_symlink() {
    local file_path="${1}"
    local link_path="${2}"
    printf "  ${__action_step} Creating symlink\n"
    printf "    ${__action_step} from \t%s\n" "${file_path}" 
    printf "    ${__action_step} to \t%s\n" "${link_path}"
    ln -s "${file_path}" "${link_path}"
}

install_dotfiles() {
    printf "${__head_action} Installing dotfiles\n"

    mkdir -p "${HOME}/dotfiles.bak"

    for dotfile in "${!__dotfiles[@]}"; do
        print_seperator
        printf "${__add_action} Adding %s\n" $(basename "${dotfile}")
        backup_dotfile "${HOME}/${__dotfiles[$dotfile]}"
        create_symlink "${__script_dir}/${dotfile}" "${HOME}/${__dotfiles[$dotfile]}"
    done

    printf "\n${__action_completed} Dotfiles was installed \\o/\n"
    print_seperator
}

install_vim_plugins() {
    local vundle_path="${HOME}/.vim/bundle/Vundle.vim"
    printf "${__head_action} Installing Vim plugins\n"
    print_seperator
    printf "${__add_action} Install Vim plugins listed in .vimrc with Vundle\n"

    printf "  ${__action_step} Download Vundle to %s\n" "${vundle_path}"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    printf "  ${__action_step} Installing plugins listed in ~/.vimrc with Vundle\n"
    vim +PluginInstall +qall

    printf "\n${__action_completed} Vim plugins was installed \\o/\n"
    print_seperator
}


main() {
    print_info
    input_prompt
    install_dotfiles
    install_vim_plugins
    printf "${__action_completed} Installation done \\o/\\o/\\o/\n"
}

main "${@}"
