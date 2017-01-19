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
  FOLDER=/tmp/powerlevel9k-test/load-test
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

function testLoadSegmentWorksOnOsx() {
    sysctl() {
        if [[ "$*" == 'vm.loadavg' ]]; then
            echo "vm.loadavg: { 1,38 1,45 2,16 }";
        fi

        if [[ "$*" == '-n hw.logicalcpu' ]]; then
            echo "4";
        fi
    }

    export OS="OSX"

    prompt_load "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{green} %F{black%}L%f %F{black}1.38 %k%F{green}%f " "${PROMPT}"

    unfunction sysctl
    unset OS
}

function testLoadSegmentWorksOnBsd() {
    sysctl() {
        if [[ "$*" == 'vm.loadavg' ]]; then
            echo "vm.loadavg: { 1,38 1,45 2,16 }";
        fi

        if [[ "$*" == '-n hw.ncpu' ]]; then
            echo "4";
        fi
    }

    export OS="BSD"

    prompt_load "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{green} %F{black%}L%f %F{black}1.38 %k%F{green}%f " "${PROMPT}"

    unfunction sysctl
    unset OS
}

function testLoadSegmentWorksOnLinux() {
    # Prepare loadavg
    mkdir proc
    echo "1.38 0.01 0.05 1/87 8641" > proc/loadavg

    alias nproc="echo 4"

    export OS="Linux"

    prompt_load "left" "1" "false" "${FOLDER}"
    p9k_build_prompt_from_cache

    assertEquals "%K{green} %F{black%}L%f %F{black}1.38 %k%F{green}%f " "${PROMPT}"

    unalias nproc
    unset OS
}

# Test normal state. This test is not OS specific.
# We test it as the Linux version, but that
# does not matter here.
function testLoadSegmentNormalState() {
    # Prepare loadavg
    mkdir proc
    echo "1.00 0.01 0.05 1/87 8641" > proc/loadavg

    alias nproc="echo 4"

    export OS="Linux"

    prompt_load "left" "1" "false" "${FOLDER}"
    p9k_build_prompt_from_cache

    assertEquals "%K{green} %F{black%}L%f %F{black}1.00 %k%F{green}%f " "${PROMPT}"

    unalias nproc
    unset OS
}

# Test warning state. This test is not OS specific.
# We test it as the Linux version, but that
# does not matter here.
function testLoadSegmentWarningState() {
    # Prepare loadavg
    mkdir proc
    echo "2.01 0.01 0.05 1/87 8641" > proc/loadavg

    alias nproc="echo 4"

    export OS="Linux"

    prompt_load "left" "1" "false" "${FOLDER}"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black%}L%f %F{black}2.01 %k%F{yellow}%f " "${PROMPT}"

    unalias nproc
    unset OS
}

# Test critical state. This test is not OS specific.
# We test it as the Linux version, but that
# does not matter here.
function testLoadSegmentCriticalState() {
    # Prepare loadavg
    mkdir proc
    echo "2.81 0.01 0.05 1/87 8641" > proc/loadavg

    alias nproc="echo 4"

    export OS="Linux"

    prompt_load "left" "1" "false" "${FOLDER}"
    p9k_build_prompt_from_cache

    assertEquals "%K{red} %F{black%}L%f %F{black}2.81 %k%F{red}%f " "${PROMPT}"

    unalias nproc
    unset OS
}

source shunit2/source/2.1/src/shunit2