#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function oneTimeSetUp() {
  source ./test/performance/libperf.zsh
}

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testViInsertModeWorks() {
  local KEYMAP='viins'

  # Load Powerlevel9k
  source segments/vi_mode.p9k

  assertEquals "%K{000} %F{004}INSERT " "$(prompt_vi_mode left 1 false)"
  samplePerformanceSilent "Vi Mode Insert" prompt_vi_mode left 1 false
}

function testViInsertModeWorksWhenLabeledAsMain() {
  local KEYMAP='main'

  # Load Powerlevel9k
  source segments/vi_mode.p9k

  assertEquals "%K{000} %F{004}INSERT " "$(prompt_vi_mode left 1 false)"
}

function testViCommandModeWorks() {
  local KEYMAP='vicmd'

  # Load Powerlevel9k
  source segments/vi_mode.p9k

  assertEquals "%K{000} %F{015}NORMAL " "$(prompt_vi_mode left 1 false)"
  samplePerformanceSilent "Vi Mode Normal" prompt_vi_mode left 1 false
}

function testViInsertModeStringIsCustomizable() {
  local KEYMAP='viins'

  # Load Powerlevel9k
  source segments/vi_mode.p9k

  assertEquals "%K{000} %F{004}INSERT " "$(prompt_vi_mode left 1 false)"
}

source shunit2/shunit2
