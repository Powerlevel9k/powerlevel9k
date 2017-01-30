# Test-VM for powerlevel9k

In this virtual machine you will find a recent ubuntu with a lot
of preinstalled ZSH frameworks (e.g. oh-my-zsh, prezto, etc.) and
- of course - powerlevel9k. The main use-case is to test the
powerlevel9k theme.

## Installation

In order to run this virtual machine, you need [vagrant](https://www.vagrantup.com/)
and [VirtualBox](http://www.virtualbox.org/).

## Running

`vagrant` is a quite easy to use command line tool to configure
a virtual machine. To fire the machine up, just run `vagrant up`.
At the first run, it will install a whole ubuntu. With `vagrant ssh`
you can log in into the machine.

## Testing

Once you have SSH'd into the machine, you'll see a plain ZSH. To
test the other frameworks, you just have to switch to one of the
following users:

  * `vagrant-antibody`
  * `vagrant-antigen`
  * `vagrant-omz`
  * `vagrant-prezto`
  * `vagrant-prezto-community`
  * `vagrant-zgen`
  * `vagrant-zim`
  * `vagrant-zplug`
  * `vagrant-zplugin`
  * `vagrant-zpm`
  * `vagrant-zulu`

To switch use `sudo -i -H -u <USERNAME>`. `-i` stands for "simulate
initial login", `-H` sets the "$HOME" variable to the directory of
the user , `-u` for the username. Otherwise you could just use
`su - <USERNAME>`.
All users have `vagrant` as password and are in the /etc/sudoers.

The regular `vagrant` user has a plain ZSH with the powerlevel9k theme.

To easily test a configuration with every user/framework, you can
create a `powerlevel9k.config` file with your powerlevel9k settings,
which gets sourced in every `.zshrc`.