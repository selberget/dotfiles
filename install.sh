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
readonly __job_task_symbol="\u21AA"
readonly __job_task_step_symbol="\u21AA"
readonly __job_completed="\U2705"
readonly __job_error="\U274C"
readonly __info_message="\u2022"
readonly __seperator="\u2501"

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
    printf "Info\n"
    print_seperator
    printf "Running the script will:\n"
    printf "  ${__info_message} Install dotfiles stored under ${__script_dir} (files suffixed with '.symlink').\n"
    printf "  ${__info_message} Create symlinks from ${HOME}/.dotfiles to where each dotfile should be stored.\n"
    printf "  ${__info_message} Backup existing dotfiles to %s, if they exist.\n" "${__dotfiles_backup_dir}"
    printf "  ${__info_message} Create symlinks for scripts under ${HOME}/.dotfiles/bin to ${HOME}/bin.\n"
    printf "  ${__info_message} Run installation scripts stored under ${HOME}/.dotfiles/**/install.sh, which will:\n"
    printf "    - install vim plugins (using Vundle)\n"
    printf "    - prompt user for git configuration\n"
    print_seperator
}

input_prompt() {
    while true; do
        read -p "Do you still wish to run the script? " response
        case "${response}" in
            [Yy]* ) printf "Proceeding with the installation...\n"; break;;
            [Nn]* ) printf "bye\n"; exit;;
        esac
    done
}

check_if_home_is_set() {
    printf "${__job_task_symbol} Checking if \$HOME is set\n"
    if [ -z "${HOME}" ]; then
        printf "  You got no \$HOME ${__job_error}\n"
        printf "  \$HOME has to be set to your home directory for the script to be able to run properly\n"
        exit 1
    else
        printf "   You got a \$HOME ${__job_completed}\n"
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

backup_backuped_dotfile() {
    local filename="${1}.bak"
    local backed_up_dotfile_path="${__dotfiles_backup_dir}/${filename}"

    printf "  ${__job_task_step_symbol} Backing up %s\n" "${filename}"    
    if [ -f "${backed_up_dotfile_path}" ]; then
        printf "    ${__job_task_step_symbol} Copying %s to %s\n" "${backed_up_dotfile_path}" "${backed_up_dotfile_path}.bak" 
        cp "${backed_up_dotfile_path}" "${backed_up_dotfile_path}.bak"
    else
        printf "    ${__job_task_step_symbol} Backed up file %s doesn't exist, no need to backup\n" "${backed_up_dotfile_path}"
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
    printf "Installing dotfiles...\n"

    
    # read dotfiles from .dotfiles/**/*.symlink
    typeset -ar dotfiles=($__script_dir/**/*.symlink)

    if [ -d "${__dotfiles_backup_dir}" ]; then
        for dotfile in $dotfiles
        do
            backup_backuped_dotfile ".$(basename ${dotfile} '.symlink')" 
        done
    else
        printf "Creating backup directory for dotfiles %s" "${__dotfiles_backup_dir}"
        mkdir -p "${__dotfiles_backup_dir}"
    fi

    # if backup directory exist backup existing backed up files
    # backup .bak files to .bak.bak files

    # else create backup directory

    # backup current dotfiles to backup directory

    #for dotfile in "${!__dotfiles[@]}"; do
        #print_seperator
        #printf "${__job_task_symbol} Adding %s\n" $(basename "${dotfile}")
        #backup_dotfile "${HOME}/${__dotfiles[$dotfile]}"
        #create_symlink "${__script_dir}/${dotfile}" "${HOME}/${__dotfiles[$dotfile]}"
    #done

    printf "\nDotfiles installed ${__job_completed}\n"
    print_seperator
}

main() {
    print_info
    input_prompt
    check_if_home_is_set
    install_dotfiles
    printf "${__job_completed} Installation done\n"
}

main "${@}"

