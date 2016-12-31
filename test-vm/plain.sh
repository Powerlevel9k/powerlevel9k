#!/usr/bin/zsh

echo '
print -P "%F{blue}INFO:%f Set your configuration in powerlevel9k.config in your powerlevel9k root folder for easier testing."
source /vagrant_data/powerlevel9k.config &>/dev/null

source /vagrant_data/powerlevel9k.zsh-theme' > ~/.zshrc
