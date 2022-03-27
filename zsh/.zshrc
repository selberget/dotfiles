# oh-my-zsh
export ZSH="/home/johan/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(docker gh)

source $ZSH/oh-my-zsh.sh

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
  [[ ! $LBUFFER =~ "\<(${(j:|:)ialiases})\$" ]]
}

is_blank_expandable_alias() {
    [[ $LBUFFER =~ "\<(${(j:|:)ealiases})\$" ]]; 
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

# aliases

# git 
alias ga='git add'
ialias gaa='git add --all'
ialias gb='git branch'
alias gbd='git branch --delete'
alias gbD='git branch -D'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcob='git checkout -b'
ialias gd='git diff'
ialias gl="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
ialias gst='git status'

# brew
ialias bulo='brew update && brew outdated'
ialias bucu='brew upgrade && brew cleanup'
ialias bli='brew list -1'

# docker
ialias dclean='docker system prune'
alias dex='docker exec --interactive --tty'
ialias di='docker images'
alias dri='docker rmi'
ialias dps='docker ps'
ialias dpsa='docker ps -a'
ialias dsra='docker stop $(docker ps --all --quiet) | xargs docker rm'
ialias dsrr='docker stop $(docker ps --quiet) | xargs docker rm'

dbash() { 
	if [ "$#" -ne "1" ]; then
		printf "dbash requires one argument (container name search string)\n" 1>&2
		return 1
	fi
	
	local container_name_filter="${1}"
	
	local container_id=$(docker ps --quiet --filter "name=${container_name_filter}")

	if [ -z "${container_id}" ]; then
		printf "Running container with name containing '${container_name_filter}' couldn't be found\n" 1>&2
		return 1
	fi
	
	
	docker exec -it "${container_id}" /bin/bash; 
}


# zsh
ialias ez='vi $HOME/.zshrc'
ialias rz='source $HOME/.zshrc'

# system
ialias ping='ping -c 5'
ialias l='ls -lh'
ialias l.='ls -ld .*'
ialias ll='ls -lAh'
ialias ls='ls --color=tty'


# expandable aliases
ealias clh='curl localhost:'

# global aliases
alias -g L='| less'
alias -g G='| grep'

# suffix aliases
alias -s {zip,ZIP}='unzip'


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
