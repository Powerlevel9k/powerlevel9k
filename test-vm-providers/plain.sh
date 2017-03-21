#!/usr/bin/zsh

echo '
LANG=en_US.UTF-8

print -P "%F{blue}INFO:%f Set your configuration in powerlevel9k.config in your powerlevel9k root folder for easier testing."
source /vagrant_data/powerlevel9k.config &>/dev/null

print -P "\nYou could switch to one of the following users (password is \"vagrant\")"
print -P "su - vagrant-antibody"
print -P "su - vagrant-antigen"
print -P "su - vagrant-omz"
print -P "su - vagrant-prezto"
print -P "su - vagrant-prezto-community"
print -P "su - vagrant-zgen"
print -P "su - vagrant-zim"
print -P "su - vagrant-zplug"
print -P "su - vagrant-zplugin"
print -P "su - vagrant-zpm"
print -P "su - vagrant-zulu"

echo ""
print -P "Have a look at the %F{blue}~/p9k%f folder for prepared test setups."

source /vagrant_data/powerlevel9k.zsh-theme' >! ~/.zshrc

# setup environment
/vagrant_data/test-vm-providers/setup-environment.sh
