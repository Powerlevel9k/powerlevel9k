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

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test/ram-test
  mkdir -p "${FOLDER}"
  cd $FOLDER
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
  p9k_clear_cache
}

function testRamSegmentWorksOnOsx() {
    alias vm_stat="echo 'Mach Virtual Memory Statistics: (page size of 4096 bytes)
Pages free:                              299687.
Pages active:                           1623792.'"

    export OS="OSX"

    prompt_ram "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black%}RAM%f %F{black}1.14G %k%F{yellow}%f " "${PROMPT}"

    unset OS
    unalias vm_stat
}

function testRamSegmentWorksOnBsd() {
    mkdir -p var/run
    echo "avail memory 5678B 299687 4444G 299" > var/run/dmesg.boot

    export OS="BSD"

    prompt_ram "left" "1" "false" "${FOLDER}"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black%}RAM%f %F{black}0.29M %k%F{yellow}%f " "${PROMPT}"

    unset OS
}

function testRamSegmentWorksOnLinux() {
    mkdir proc
    echo "MemAvailable: 299687" > proc/meminfo

    export OS="Linux"

    prompt_ram "left" "1" "false" "${FOLDER}"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black%}RAM%f %F{black}0.29G %k%F{yellow}%f " "${PROMPT}"

    unset OS
}

source shunit2/source/2.1/src/shunit2