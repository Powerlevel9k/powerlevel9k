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

function testViInsertModeWorks() {
  export KEYMAP='viins'

  prompt_vi_mode "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{blue}INSERT %k%F{black}%f " "${PROMPT}"

  unset KEYMAP
}

function testViInsertModeWorksWhenLabeledAsMain() {
  export KEYMAP='main'

  prompt_vi_mode "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{blue}INSERT %k%F{black}%f " "${PROMPT}"

  unset KEYMAP
}

function testViCommandModeWorks() {
  export KEYMAP='vicmd'

  prompt_vi_mode "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}NORMAL %k%F{black}%f " "${PROMPT}"

  unset KEYMAP
}

function testViInsertModeStringIsCustomizable() {
  export KEYMAP='viins'

  prompt_vi_mode "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{blue}INSERT %k%F{black}%f " "${PROMPT}"

  unset KEYMAP
}

source shunit2/source/2.1/src/shunit2