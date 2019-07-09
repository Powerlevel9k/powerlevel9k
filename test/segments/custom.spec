#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testCustomDirectOutputSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  local P9K_CUSTOM_WORLD="echo world"

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testCustomClosureSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  function p9k_hello_world() {
    echo "world"
  }
  local P9K_CUSTOM_WORLD='p9k_hello_world'

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testSettingBackgroundForCustomSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  local P9K_CUSTOM_WORLD="echo world"
  local P9K_CUSTOM_WORLD_BACKGROUND="yellow"

  assertEquals "%K{003} %F{000}world %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testSettingForegroundForCustomSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  local P9K_CUSTOM_WORLD="echo world"
  local P9K_CUSTOM_WORLD_FOREGROUND="red"

  assertEquals "%K{015} %F{001}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testSettingVisualIdentifierForCustomSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  local P9K_CUSTOM_WORLD="echo world"
  local P9K_CUSTOM_WORLD_ICON="hw"

  assertEquals "%K{015} %F{000}hw%f %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testSettingVisualIdentifierForegroundColorForCustomSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  local P9K_CUSTOM_WORLD="echo world"
  local P9K_CUSTOM_WORLD_ICON="hw"
  local P9K_CUSTOM_WORLD_ICON_COLOR="red"

  assertEquals "%K{015} %F{001}hw%f %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2
