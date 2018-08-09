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

function testIpSegmentPrintsNothingOnOsxIfNotConnected() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip custom_world)
  alias networksetup='echo "not connected"'
  local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"

  local OS="OSX" # Fake OSX

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"

  unalias networksetup
}

function testIpSegmentPrintsNothingOnLinuxIfNotConnected() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip custom_world)
  alias ip='echo "not connected"'
  local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"

  local OS="Linux" # Fake Linux

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"

  unalias ip
}

function testIpSegmentWorksOnOsxWithNoInterfaceSpecified() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip)
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

  local OS='OSX' # Fake OSX

  assertEquals "%K{cyan} %F{black}IP %f%F{black}1.2.3.4 %k%F{cyan}%f " "$(__p9k_build_left_prompt)"

  unalias ipconfig
  unalias networksetup
}

# There could be more than one confiured network interfaces.
# `networksetup -listnetworkserviceorder` lists the interfaces
# in hierarchical order, but from outside this is not obvious
# (implementation detail). So we need a test for this case.
function testIpSegmentWorksOnOsxWithMultipleInterfacesSpecified() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip)
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

  local OS='OSX' # Fake OSX

  assertEquals "%K{cyan} %F{black}IP %f%F{black}1.2.3.4 %k%F{cyan}%f " "$(__p9k_build_left_prompt)"

  unfunction ipconfig
  unalias networksetup
}

function testIpSegmentWorksOnOsxWithInterfaceSpecified() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(ip)
  local P9K_IP_INTERFACE='xxx'
  alias ipconfig="_(){ echo '1.2.3.4'; };_"

  local OS='OSX' # Fake OSX

  assertEquals "%K{cyan} %F{black}IP %f%F{black}1.2.3.4 %k%F{cyan}%f " "$(__p9k_build_left_prompt)"

  unalias ipconfig
}

source shunit2/shunit2
