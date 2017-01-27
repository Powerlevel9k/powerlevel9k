#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  # Disable TRAP, so that we have more control how the segment is build,
  # as shUnit does not work with async commands.
  trap WINCH
}

function tearDown() {
  p9k_clear_cache
}

function testIpSegmentPrintsNothingOnOsxIfNotConnected() {
  alias networksetup='echo "not connected"'
  OS="OSX"
  POWERLEVEL9K_CUSTOM_WORLD='echo world'

  prompt_custom "left" "2" "world" "false"
  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
  unset OS
  unalias networksetup
}

function testIpSegmentPrintsNothingOnLinuxIfNotConnected() {
  alias ip='echo "not connected"'
  OS="Linux"
  POWERLEVEL9K_CUSTOM_WORLD='echo world'

  prompt_custom "left" "2" "world" "false"
  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
  unset OS
  unalias ip
}

function testIpSegmentWorksOnOsxWithNoInterfaceSpecified() {
  export OS='OSX'
  alias networksetup="echo 'An asterisk (*) denotes that a network service is disabled.
(1) Ethernet
(Hardware Port: Ethernet, Device: en0)

(2) FireWire
(Hardware Port: FireWire, Device: fw0)

(3) Wi-Fi
(Hardware Port: Wi-Fi, Device: en1)

(4) Bluetooth PAN
(Hardware Port: Bluetooth PAN, Device: en3)

(5) Thunderbolt Bridge
(Hardware Port: Thunderbolt Bridge, Device: bridge0)

(6) Apple USB Ethernet Adapter
(Hardware Port: Apple USB Ethernet Adapter, Device: en4)
'"

  alias ipconfig="_(){ echo '1.2.3.4'; };_"

  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{cyan} %F{black%}IP%f %F{black}1.2.3.4 %k%F{cyan}%f " "${PROMPT}"

  unalias ipconfig
  unalias networksetup
  unset OS
}

# There could be more than one confiured network interfaces.
# `networksetup -listnetworkserviceorder` lists the interfaces
# in hierarchical order, but from outside this is not obvious
# (implementation detail). So we need a test for this case.
function testIpSegmentWorksOnOsxWithMultipleInterfacesSpecified() {
  export OS='OSX'
  alias networksetup="echo 'An asterisk (*) denotes that a network service is disabled.
(1) Ethernet
(Hardware Port: Ethernet, Device: en0)

(2) FireWire
(Hardware Port: FireWire, Device: fw0)

(3) Wi-Fi
(Hardware Port: Wi-Fi, Device: en1)

(4) Bluetooth PAN
(Hardware Port: Bluetooth PAN, Device: en3)

(5) Thunderbolt Bridge
(Hardware Port: Thunderbolt Bridge, Device: bridge0)

(6) Apple USB Ethernet Adapter
(Hardware Port: Apple USB Ethernet Adapter, Device: en4)
'"

  # Return a unique IP address for every interface
  ipconfig() {
      case "${2}" {
          en0)
            echo 1.2.3.4
          ;;
          fw0)
            echo 2.3.4.5
          ;;
          en1)
            echo 3.4.5.6
          ;;
          en3)
            echo 4.5.6.7
          ;;
      }
  }

  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{cyan} %F{black%}IP%f %F{black}1.2.3.4 %k%F{cyan}%f " "${PROMPT}"

  unfunction ipconfig
  unalias networksetup
  unset OS
}

function testIpSegmentWorksOnOsxWithInterfaceSpecified() {
  export OS='OSX'
  POWERLEVEL9K_IP_INTERFACE='xxx'
  alias ipconfig="_(){ echo '1.2.3.4'; };_"

  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{cyan} %F{black%}IP%f %F{black}1.2.3.4 %k%F{cyan}%f " "${PROMPT}"

  unalias ipconfig
  unset POWERLEVEL9K_IP_INTERFACE
  unset OS
}

function testIpSegmentWorksOnLinuxWithNoInterfaceSpecified() {
    setopt aliases
    export OS='Linux'
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

  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{cyan} %F{black%}IP%f %F{black}10.0.2.15 %k%F{cyan}%f " "${PROMPT}"

  unfunction ip
  unset OS
}

function testIpSegmentWorksOnLinuxWithMultipleInterfacesSpecified() {
    setopt aliases
    export OS='Linux'
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

  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{cyan} %F{black%}IP%f %F{black}10.0.2.15 %k%F{cyan}%f " "${PROMPT}"

  unfunction ip
  unset OS
}

function testIpSegmentWorksOnLinuxWithInterfaceSpecified() {
  export OS='Linux'
  POWERLEVEL9K_IP_INTERFACE='xxx'
  ip(){
    echo '2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
inet 10.0.2.15/24 brd 10.0.2.255 scope global eth0
    valid_lft forever preferred_lft forever';
   }

  prompt_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{cyan} %F{black%}IP%f %F{black}10.0.2.15 %k%F{cyan}%f " "${PROMPT}"

  unfunction ip
  unset OS
}

source shunit2/source/2.1/src/shunit2