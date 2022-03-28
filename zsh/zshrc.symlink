# oh-my-zsh
export ZSH="${HOME}/.oh-my-zsh"
export DOTFILES_ZSH="${HOME}/Projects/dotfiles"

ZSH_THEME="robbyrussell"

plugins=(docker gh)

source ${ZSH}/oh-my-zsh.sh

if [[ -a "${HOME}/.zshrc-local" ]]; then
    source "${HOME}/.zshrc-local"
fi

# load zsh configuration
typeset -U config_files
config_files=($DOTFILES_ZSH/**/*.zsh)

for file in ${(M)config_files:#*/autocomplete.zsh}; do
    source ${file}
done

for file in ${(M)config_files:#*/aliases.zsh}; do
    source ${file}
done

unset config_files

# sdkman - this has to be eof for some reason
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
