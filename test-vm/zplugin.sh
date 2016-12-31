#!/usr/bin/zsh
# We need to run this script in ZSH, so that switching user works!
NEW_USER=vagrant-zplugin
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
        
        # install zplugin
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/psprint/zplugin/master/doc/install.sh)"

        mkdir -p ~/.zplugin/snippets
        ln -s /vagrant_data ~/.zplugin/snippets/--SLASH--vagrant_data--SLASH--powerlevel9k--DOT--zsh-theme

        echo "
print -P '%F{blue}INFO:%f Set your configuration in powerlevel9k.config in your powerlevel9k root folder for easier testing.'
source /vagrant_data/powerlevel9k.config &>/dev/null

zplugin load psprint zsh-navigation-tools\n
zplugin load psprint---zprompts\n
zplugin snippet /vagrant_data/powerlevel9k.zsh-theme\n
" >> ~/.zshrc
)