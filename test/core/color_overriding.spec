#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testDynamicColoringOfSegmentsWork() {
  local P9K_LEFT_PROMPT_ELEMENTS=(date)
  local P9K_DATE_ICON="date-icon"
  local P9K_DATE_BACKGROUND='red'
  source segments/date.p9k

  assertEquals "%K{001} %F{000}date-icon %f%F{000}%D{%d.%m.%y} %k%F{001}%f " "$(__p9k_build_left_prompt)"
}

function testDynamicColoringOfVisualIdentifiersWork() {
  local P9K_LEFT_PROMPT_ELEMENTS=(date)
  local P9K_DATE_ICON="date-icon"
  local P9K_DATE_ICON_COLOR='green'
  source segments/date.p9k

  assertEquals "%K{015} %F{002}date-icon %f%F{000}%D{%d.%m.%y} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(date)
  local P9K_DATE_ICON="date-icon"
  local P9K_DATE_ICON_COLOR='green'
  local P9K_DATE_FOREGROUND='red'
  local P9K_DATE_BACKGROUND='yellow'
  source segments/date.p9k

  assertEquals "%K{003} %F{002}date-icon %f%F{001}%D{%d.%m.%y} %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingOfStatefulSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(host)
  local P9K_HOST_REMOTE_ICON="ssh-icon"
  local P9K_HOST_REMOTE_BACKGROUND='red'
  local P9K_HOST_REMOTE_FOREGROUND='green'
  # Provoke state
  local SSH_CLIENT="x"
  source segments/host.p9k

  assertEquals "%K{001} %F{002}ssh-icon %f%F{002}%m %k%F{001}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingOfCustomSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  local P9K_WORLD_ICON='CW'
  local P9K_WORLD_ICON_COLOR='green'
  local P9K_WORLD_FOREGROUND='red'
  local P9K_WORLD_BACKGROUND='red'
  p9k::register_segment "WORLD"

  assertEquals "%K{001} %F{002}CW %f%F{001}world %k%F{001}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2
