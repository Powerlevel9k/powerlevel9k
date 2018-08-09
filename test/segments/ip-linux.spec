#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/ip.p9k
}

function testIpSegmentWorksOnLinuxWithNoInterfaceSpecified() {
  setopt aliases
  local P9K_LEFT_PROMPT_ELEMENTS=(ip)
  # That command is harder to test, as it is used at first
  # to get all relevant network interfaces and then for
  # getting the configuration of that segment..
  ip(){
    if [[ "$*" == 'link ls up' ]]; then
    echo "1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
  link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
  link/ether 08:00:27:7e:84:45 brd ff:ff:ff:ff:ff:ff";
    fi

    if [[ "$*" == '-4 a show eth0' ]]; then
    echo '2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
  inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
     valid_lft forever preferred_lft forever';
    fi
  }

  local OS='Linux' # Fake Linux

  assertEquals "%K{006} %F{000}IP %f%F{000}10.0.2.15 %k%F{006}%f " "$(__p9k_build_left_prompt)"

  unfunction ip
}

function testIpSegmentWorksOnLinuxWithMultipleInterfacesSpecified() {
  setopt aliases
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip)
  # That command is harder to test, as it is used at first
  # to get all relevant network interfaces and then for
  # getting the configuration of that segment..
  ip(){
    if [[ "$*" == 'link ls up' ]]; then
    echo "1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
  link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
  link/ether 08:00:27:7e:84:45 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
  link/ether 08:00:27:7e:84:45 brd ff:ff:ff:ff:ff:ff
4: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
  link/ether 08:00:27:7e:84:45 brd ff:ff:ff:ff:ff:ff";
    fi

    if [[ "$*" == '-4 a show eth1' ]]; then
    echo '3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
  inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
     valid_lft forever preferred_lft forever';
    fi
  }

  local OS='Linux' # Fake Linux

  assertEquals "%K{006} %F{000}IP %f%F{000}10.0.2.15 %k%F{006}%f " "$(__p9k_build_left_prompt)"

  unfunction ip
}

function testIpSegmentWorksOnLinuxWithInterfaceSpecified() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip)
  local P9K_IP_INTERFACE='xxx'
  ip(){
  echo '2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
  valid_lft forever preferred_lft forever';
  }

  local OS='Linux' # Fake Linux

  assertEquals "%K{006} %F{000}IP %f%F{000}10.0.2.15 %k%F{006}%f " "$(__p9k_build_left_prompt)"

  unfunction ip
}

source shunit2/shunit2
