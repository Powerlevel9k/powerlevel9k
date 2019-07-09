#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=()

  source test/helper/build_prompt_wrapper.sh
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/vi_mode/vi_mode.p9k
}

function tearDown() {
  # Reset redeclaration of p9k::prepare_segment
  __p9k_reset_prepare_segment
}

function testViInsertModeWorks() {
  local KEYMAP='viins'

  __p9k_make_prepare_segment_print "left" "1"

  assertEquals "%K{000} %F{004}INSERT " "$(prompt_vi_mode left 1 false)"
}

function testViInsertModeWorksWhenLabeledAsMain() {
  local KEYMAP='main'

  __p9k_make_prepare_segment_print "left" "1"

  assertEquals "%K{000} %F{004}INSERT " "$(prompt_vi_mode left 1 false)"
}

function testViCommandModeWorks() {
  local KEYMAP='vicmd'

  __p9k_make_prepare_segment_print "left" "1"

  assertEquals "%K{000} %F{015}NORMAL " "$(prompt_vi_mode left 1 false)"
}

function testViInsertModeStringIsCustomizable() {
  local KEYMAP='viins'

  __p9k_make_prepare_segment_print "left" "1"

  assertEquals "%K{000} %F{004}INSERT " "$(prompt_vi_mode left 1 false)"
}

source shunit2/shunit2
