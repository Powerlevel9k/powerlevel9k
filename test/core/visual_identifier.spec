#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source functions/*
}

function testOverwritingIconsWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_WORLD1_ICON='*icon-here'
  registerSegment "WORLD1"

  assertEquals "%K{white} %F{black}*icon-here %f%F{black}world1 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testVisualIdentifierAppearsBeforeSegmentContentOnLeftSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_WORLD1_ICON='*icon-here'
  registerSegment "WORLD1"

  assertEquals "%K{white} %F{black}*icon-here %f%F{black}world1 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testVisualIdentifierAppearsAfterSegmentContentOnRightSegments() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_WORLD1_ICON='*icon-here'
  registerSegment "WORLD1"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black}*icon-here " "$(buildRightPrompt)"
}

function testVisualIdentifierPrintsNothingIfNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'

  assertEquals "%K{white} %F{black}*icon-here %f%F{black}world1 %k%F{white}%f " "$(buildLeftPrompt)"
}

source shunit2/source/2.1/src/shunit2
