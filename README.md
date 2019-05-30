# Dotfiles

Repository for handling my dotfiles, with support for automatically install them on a new system.

## Installation

Run the following commands in your terminal.
```
git clone git@github.com:selberget/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```
**Note:** Vim plugins listed in the *.vimrc* will be installed automatically using *Vundle*, when executing the installation script.

### Sources used for writing bash script
[1] http://bash3boilerplate.sh/
[2] https://github.com/bertvv/dotfiles/blob/master/.vim/templates/sh
[3] https://github.com/ralish/bash-script-template/blob/stable/script.sh
