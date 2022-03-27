#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# unicode symbols
readonly ok_symbol="\u2705"
readonly error_symbol="\u274C"

set_author() {
    local git_username
    printf "Enter git  username: "
    read -e git_username

    git config --global user.name "${git_username}"
}

set_mail() {
    local git_email
    printf "Enter git email: "
    read -e git_email

    git config --global user.email "${git_email}"
}

set_credential_helper() {
    local git_credential="cache"

    if [ $(uname --kernel-name) == "Darwin" ]; then
        git_credential="osxkeychain"
    fi
    
    printf "Setting credential.helper=${git_credential}\n"
    git config --global credential.helper "${git_credential}"
}

check_requirements() {
    local git_command="git"

    if ! command -v "${git_command}" &> /dev/null; then
        printf "  ${error_symbol} ${git_command} is required to be installed\n" 
        printf "git won't be configured"
        exit 0 # or 1?
    fi
}

main() {
    printf "Configuring git...\n"
    check_requirements
    set_author
    set_mail
    set_credential_helper
}

main "${@}"

