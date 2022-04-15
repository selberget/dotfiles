# functionality for expandable aliases
# https://github.com/sdaschner/dotfiles/blob/master/.oh-my-zsh/custom/autocomplete.zsh

typeset -a ealiases
ealiases=()

ealias() {
  alias "${@}"
  args="${@}"
  args="${args%%\=*}"
  ealiases+=(${args##* })
}

typeset -a ialiases
ialiases=()

ialias() {
  alias "${@}"
  args="${@}"
  args="${args%%\=*}"
  ialiases+=(${args##* })
}

is_expandable_alias() {
    [[ ${ialiases[(ie)$LBUFFER]} -gt ${#ialiases} ]];
}

is_blank_expandable_alias() {
    [[ ${ealiases[(ie)$LBUFFER]} -le ${#ealiases} ]];
}

# expand expandable aliases
expand-expandable-alias() {
    is_blank_expandable_alias
    local insert_blank=$?

    if is_expandable_alias; then
        zle _expand_alias
    fi

    zle self-insert

    if [ $insert_blank = "0" ]; then
        zle backward-delete-char
    fi
}

zle -N expand-expandable-alias

bindkey " " expand-expandable-alias
bindkey -M isearch " " magic-space

