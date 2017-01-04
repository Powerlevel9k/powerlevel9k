#!/usr/bin/zsh
# We need to run this script in ZSH, so that switching user works!
NEW_USER=vagrant-zim
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

        git clone --recursive https://github.com/Eriner/zim.git "${ZDOTDIR:-${HOME}}/.zim"

        setopt EXTENDED_GLOB
        for template_file ( ${ZDOTDIR:-${HOME}}/.zim/templates/* ); do
            user_file="${ZDOTDIR:-${HOME}}/.${template_file:t}"
            touch ${user_file}
            ( print -rn "$(<${template_file})$(<${user_file})" >! ${user_file} ) 2>/dev/null
        done
        source "${ZDOTDIR:-${HOME}}/.zlogin"

        ln -s /vagrant_data ~/.zim/modules/prompt/external-themes/powerlevel9k
        ln -s ~/.zim/modules/prompt/external-themes/powerlevel9k/powerlevel9k.zsh-theme ~/.zim/modules/prompt/functions/prompt_powerlevel9k_setup
        # prepend config to zshrc
        echo -e "source /vagrant_data/powerlevel9k.config &>/dev/null\n$(cat ~/.zshrc)" > ~/.zshrc
        # Prepend installation path to zshrc
        echo -e "POWERLEVEL9K_INSTALLATION_PATH=~/.zim/modules/prompt/external-themes/powerlevel9k/powerlevel9k.zsh-theme\n$(cat ~/.zshrc)" > ~/.zshrc
        sed -i "s/zprompt_theme='steeef'/zprompt_theme='powerlevel9k'/g" ~/.zimrc

        echo "
print -P '%F{blue}INFO:%f Set your configuration in powerlevel9k.config in your powerlevel9k root folder for easier testing.'
source /vagrant_data/powerlevel9k.config &>/dev/null
" >> ~/.zimrc
)
