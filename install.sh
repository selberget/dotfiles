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
    printf "Checking if \$HOME is set\n"
    if [ -z "${HOME}" ]; then
        printf "  ${__job_task_step_symbol} You got no \$HOME ${__job_error}\n"
        printf "  \$HOME has to be set to your home directory for the script to be able to run properly\n"
        exit 1
    else
        printf "   You got a \$HOME ${__job_completed}\n"
    fi
    print_seperator
}

backup_dotfile() {
    local dotfile_name="${1}"
    local dotfile_path="${HOME}/${dotfile_name}"
    local backup_dotfile_path="${__dotfiles_backup_dir}/${dotfile_name}.bak"

    printf "Backing up %s\n" "${dotfile_name}"

    if [ -f "${dotfile_path}" ] ; then
        printf "  ${__job_task_step_symbol} %s exists on the system\n" "${dotfile_name}"
        printf "  ${__job_task_step_symbol} Copying %s to %s\n" "${dotfile_name}" "${__dotfiles_backup_dir}" 
        cp  "${dotfile_path}" "${backup_dotfile_path}"
        printf "  ${__job_task_step_symbol} Removing old %s from the system\n" "${dotfile_name}"
        rm -f "${dotfile_path}"
    else
        printf "  ${__job_task_step_symbol} %s doesn't exist\n" "${dotfile_name}"
        printf "  ${__job_task_step_symbol} No need to backup\n"
    fi
}

backup_backuped_dotfile() {
    local filename="${1}.bak"
    local backed_up_dotfile_path="${__dotfiles_backup_dir}/${filename}"

    printf "Backing up previous backup %s\n" "${filename}"    
    if [ -f "${backed_up_dotfile_path}" ]; then
        printf "  ${__job_task_step_symbol} Copying %s to %s\n" "${backed_up_dotfile_path}" "${backed_up_dotfile_path}.bak" 
        cp "${backed_up_dotfile_path}" "${backed_up_dotfile_path}.bak"
    else
        printf "  ${__job_task_step_symbol} Backed up file %s doesn't exist, no need to backup\n" "${backed_up_dotfile_path}"
    fi
}

create_symlink() {
    local file_path="${1}"
    local link_path="${2}"
    printf "Creating symlink from %s to %s\n" "${file_path}" "${link_path}"
    ln -s "${file_path}" "${link_path}"
}

install_dotfiles() {
    printf "Installing dotfiles...\n"
    
    printf "Creating backup directory for dotfiles %s\n" "${__dotfiles_backup_dir}"
    mkdir -p "${__dotfiles_backup_dir}"

    # read dotfiles paths
    typeset -ar dotfiles=($__script_dir/**/*.symlink)
    local dotfile_name

    for dotfile in "${dotfiles[@]}"
    do
        dotfile_name=".$(basename ${dotfile} '.symlink')" 
        backup_backuped_dotfile "${dotfile_name}"
        backup_dotfile "${dotfile_name}"
        create_symlink "${dotfile}" "${HOME}/${dotfile_name}"
    done

    printf "\nDotfiles installed ${__job_completed}\n"
    print_seperator
}

install_scripts() {
    local script_source="${__script_dir}/bin"
    local script_destination="${HOME}/bin"

    printf "Installing scripts from bin/...\n"
    if [ ! -d $script_destination ]; then
        printf "Creating directory for local scripts at %s\n" "${script_destination}"
        mkdir -p ${script_destination}
    fi

    printf "Following scripts will be installed:\n"
    for script in "${script_source}/*"
    do
        printf "${__info_message} $(basename $script)\n"
    done

    printf "Copying scripts from %s to %s\n" "${script_source}" "${script_destination}"
    cp -a "${script_source}/." "${script_destination}"

    printf "\nScripts installed ${__job_completed}\n"
    print_seperator
}

run_installation_scripts() {
    for install_script in ${__script_dir}/**/install.sh
    do
        printf "Running installation script %s\n" "${install_script}"
        ${install_script}
    done

    printf "\nInstallation scripts executed ${__job_completed}\n"
    print_seperator
}

check_requirements() {
    if [[ "${HOME}/.dotfiles" != "${__script_dir}" ]]; then
        printf "Repository is required to be located under %s, won't work with current location at %s %s\n" "${HOME}/.dotfiles" "${__script_dir}" "${__job_error}"
        exit 1
    fi
}

main() {
    check_requirements
    print_info
    input_prompt
    check_if_home_is_set
    install_dotfiles
    install_scripts
    run_installation_scripts
    printf "Installation done ${__job_completed}\n"
}

main "${@}"

