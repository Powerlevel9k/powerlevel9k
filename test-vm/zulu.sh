#!/usr/bin/zsh
# We need to run this script in ZSH, so that switching user works!
NEW_USER=vagrant-zulu
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

        # install zulu https://github.com/zulu-zsh/zulu
        curl -L https://git.io/zulu-install | zsh && zsh

        # For this installation, we just need to add the powerlevel9k path
        # to ZSH's FPATH. The `powerlevel9k.zsh-theme` file should be
        # symlinked to `prompt_powerlevel9k_setup` when https://github.com/bhilburn/powerlevel9k/pull/393
        # is merged.
        echo "
zulu fpath add /vagrant_data
zulu fpath add /vagrant_data/functions
export POWERLEVEL9K_INSTALLATION_PATH=/vagrant_data
zulu theme powerlevel9k
" >> ~/.zshrc

        echo "
print -P '%F{blue}INFO:%f Set your configuration in powerlevel9k.config in your powerlevel9k root folder for easier testing.'
source /vagrant_data/powerlevel9k.config &>/dev/null
" >> ~/.zshrc
)