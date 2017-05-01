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
  # Resets if someone has set these in his/hers env
  unset POWERLEVEL9K_STATUS_VERBOSE
  unset POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE

  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test/swap-test
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

function testStatusPrintsNothingIfReturnCodeIsZeroAndVerboseIsUnset() {
    export RETVAL=0
    POWERLEVEL9K_CUSTOM_WORLD='echo world'

    prompt_custom "left" "2" "world" "false"
    prompt_status "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unset RETVAL
}

function testStatusWorksAsExpectedIfReturnCodeIsZeroAndVerboseIsSet() {
    export RETVAL=0
    POWERLEVEL9K_STATUS_VERBOSE=true

    prompt_status "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{green%}✓%f %F{green}0 %k%F{black}%f " "${PROMPT}"

    unset POWERLEVEL9K_STATUS_VERBOSE
    unset RETVAL
}

function testStatusInGeneralErrorCase() {
    export RETVAL=1

    prompt_status "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{red%}✘%f %F{red}1 %k%F{black}%f " "${PROMPT}"

    unset RETVAL
}

source shunit2/source/2.1/src/shunit2