# Dotfiles

Repository for handling my dotfiles.

Heavily inspired by [holman/dotfiles](https://github.com/holman/dotfiles).

Also borrowed a lot from [sdaschner/dotfiles](https://github.com/sdaschner/dotfiles), especially the handling of zsh aliases.

He has a blog post on zsh aliases [here](https://blog.sebastian-daschner.com/entries/zsh-aliases).

## Installation

Installation script will:
* Backup existing dotfiles to `$HOME/dotfiles.bak`
* Create symlink for dotfiles (suffixed .symlink) into `$HOME`
* Copy scripts under `bin/` to `$HOME/bin`
* Run installation scripts in sub directories (`${HOME}/.dotfiles/**/install.sh`), which currently will:
    - install vim plugins listed in vim/vimrc.symlink using Vundle
    - prompt for git configuration

Run the following commands in your terminal.
```
git clone git@github.com:selberget/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

For local/private zsh configuration use `${HOME}/.zshrc-local`, which will be sourced by `.zshrc` if it exists.

