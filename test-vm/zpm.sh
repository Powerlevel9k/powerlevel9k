#!/usr/bin/zsh
# We need to run this script in ZSH, so that switching user works!
NEW_USER=vagrant-zpm
# Create User
PASSWORD='$6$OgLg9v2Z$Db38Jr9inZG7y8BzL8kqFK23fF5jZ7FU1oiIBLFjNYR9XVX03fwQayMgA6Rm1rzLbXaf.gkZaTWhB9pv5XLq11'
useradd -p $PASSWORD -g vagrant -s $(which zsh) -m $NEW_USER
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$NEW_USER
chmod 440 /etc/sudoers.d/$NEW_USER

(
        # Change User (See http://unix.stackexchange.com/questions/86778/why-cant-we-execute-a-list-of-commands-as-different-user-without-sudo)
        USERNAME=$NEW_USER
        #UID=$(id -u $NEW_USER)
        #EUID=$(id -u $NEW_USER)
        HOME=/home/$NEW_USER

        echo "
print -P '%F{blue}INFO:%f Set your configuration in powerlevel9k.config in your powerlevel9k root folder for easier testing.'
source /vagrant_data/powerlevel9k.config &>/dev/null

source ~/.zpm/zpm.zsh

Plug powerlevel9k
" > ~/.zshrc

        # install zpm
        git clone --recursive https://github.com/horosgrisa/zpm ~/.zpm
        # Install powerlevel9k
        mkdir ~/.zpm/plugins/powerlevel9k
        ln -s /vagrant_data/powerlevel9k.zsh-theme ~/.zpm/plugins/powerlevel9k/powerlevel9k.plugin.zsh
)
