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
  local P9K_DATE_ICON="*date-icon"
  local P9K_DATE_BACKGROUND='red'
  source segments/date.p9k

  assertEquals "%K{red} %F{black}*date-icon %f%F{black}%D{%d.%m.%y} %k%F{red}%f " "$(__p9k_build_left_prompt)"
}

function testDynamicColoringOfVisualIdentifiersWork() {
  local P9K_LEFT_PROMPT_ELEMENTS=(date)
  local P9K_DATE_ICON="*date-icon"
  local P9K_DATE_ICON_COLOR='green'
  source segments/date.p9k

  assertEquals "%K{white} %F{green}*date-icon %f%F{black}%D{%d.%m.%y} %k%F{white}%f " "$(__p9k_build_left_prompt)"
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(date)
  local P9K_DATE_ICON="*date-icon"
  local P9K_DATE_ICON_COLOR='green'
  local P9K_DATE_FOREGROUND='red'
  local P9K_DATE_BACKGROUND='yellow'
  source segments/date.p9k

  assertEquals "%K{yellow} %F{green}*date-icon %f%F{red}%D{%d.%m.%y} %k%F{yellow}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingOfStatefulSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(host)
  local P9K_HOST_REMOTE_ICON="*ssh-icon"
  local P9K_HOST_REMOTE_BACKGROUND='red'
  local P9K_HOST_REMOTE_FOREGROUND='green'
  # Provoke state
  local SSH_CLIENT="x"
  source segments/host.p9k

  assertEquals "%K{red} %F{green}*ssh-icon %f%F{green}%m %k%F{red}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingOfCustomSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  local P9K_WORLD_ICON='*CW'
  local P9K_WORLD_ICON_COLOR='green'
  local P9K_WORLD_FOREGROUND='red'
  local P9K_WORLD_BACKGROUND='red'
  p9k::register_segment "WORLD"

  assertEquals "%K{red} %F{green}*CW %f%F{red}world %k%F{red}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/source/2.1/src/shunit2
