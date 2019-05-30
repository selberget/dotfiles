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
readonly __dotfiles_backup_dir="${HOME}/dotfiles.bak"

# unicode symbols
readonly __job_symbol="\u226B"
readonly __job_task_symbol="\u2300"
readonly __job_task_step_symbol="\u21AA"
readonly __job_completed="\u2713"
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
    printf "${__job_symbol} Info\n"
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
        printf "${__job_task_symbol} "
        read -p "Do you still wish to run the script? " response
        case "${response}" in
            [Yy]* ) printf "  ${__job_task_step_symbol} Proceeding with the installation! \\o/\n"; break;;
            [Nn]* ) printf "  ${__job_task_step_symbol} bye :(\n"; exit;;
        esac
    done
}

check_if_home_is_set() {
    printf "${__job_task_symbol} Checking if \$HOME is set\n"
    if [ -z "${HOME}" ]; then
        printf "  ${__job_task_step_symbol} You got no \$HOME :(\n"
        printf "    ${__job_task_step_symbol} \$HOME has to be set to your home directory for the script\n" 
        printf "      to be able to run properly\n"
        exit 1
    else
        printf "  ${__job_task_step_symbol} You got a \$HOME \\o/\n"
    fi
    print_seperator
}

backup_dotfile() {
    local dotfile_path="${1}"

    printf "  ${__job_task_step_symbol} Backing up %s\n" $(basename "${dotfile_path}")

    if [ -f "${dotfile_path}" ] || [ -d "${dotfile_path}" ]; then
        printf "    ${__job_task_step_symbol} %s exists on the system\n" $(basename "${dotfile_path}")
        printf "      ${__job_task_step_symbol} Copying %s to %s\n" $(basename "${dotfile_path}") "${__dotfiles_backup_dir}" 
        cp -r "${dotfile_path}" "${__dotfiles_backup_dir}"
        printf "      ${__job_task_step_symbol} Removing old %s from the system\n" $(basename "${dotfile_path}")
        rm -rf "${dotfile_path}"
    else
        printf "    ${__job_task_step_symbol} %s doesn't exist\n" $(basename "${dotfile_path}")
        printf "      ${__job_task_step_symbol} No need to backup\n"
    fi
}

create_symlink() {
    local file_path="${1}"
    local link_path="${2}"
    printf "  ${__job_task_step_symbol} Creating symlink\n"
    printf "    ${__job_task_step_symbol} from \t%s\n" "${file_path}" 
    printf "    ${__job_task_step_symbol} to \t%s\n" "${link_path}"
    ln -s "${file_path}" "${link_path}"
}

install_dotfiles() {
    printf "${__job_symbol} Installing dotfiles\n"

    mkdir -p "${__dotfiles_backup_dir}"

    for dotfile in "${!__dotfiles[@]}"; do
        print_seperator
        printf "${__job_task_symbol} Adding %s\n" $(basename "${dotfile}")
        backup_dotfile "${HOME}/${__dotfiles[$dotfile]}"
        create_symlink "${__script_dir}/${dotfile}" "${HOME}/${__dotfiles[$dotfile]}"
    done

    printf "\n${__job_completed} Dotfiles was installed \\o/\n"
    print_seperator
}

install_vim_plugins() {
    local vundle_path="${HOME}/.vim/bundle/Vundle.vim"
    printf "${__job_symbol} Installing Vim plugins\n"
    print_seperator
    printf "${__job_task_symbol} Install Vim plugins listed in .vimrc with Vundle\n"

    printf "  ${__job_task_step_symbol} Download Vundle to %s\n" "${vundle_path}"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    printf "  ${__job_task_step_symbol} Installing plugins listed in ~/.vimrc with Vundle\n"
    vim +PluginInstall +qall

    printf "\n${__job_completed} Vim plugins was installed \\o/\n"
    print_seperator
}


main() {
    print_info
    input_prompt
    check_if_home_is_set
    install_dotfiles
    install_vim_plugins
    printf "${__job_completed} Installation done \\o/\\o/\\o/\n"
}

main "${@}"
