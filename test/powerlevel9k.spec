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
  source segments/dir.p9k

  # Unset mode, so that user settings
  # do not interfere with tests
}

function testJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir dir_joined)
  cd /tmp

  assertEquals "%K{004} %F{000}/tmp %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testTransitiveJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir root_indicator_joined dir_joined)
  cd /tmp

  assertEquals "%K{004} %F{000}/tmp %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testJoiningWithConditionalSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir background_jobs dir_joined)
  source segments/background_jobs.p9k

  cd /tmp

  assertEquals "%K{004} %F{000}/tmp  %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testDynamicColoringOfSegmentsWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_BACKGROUND='red'
  source segments/dir.p9k

  cd /tmp

  assertEquals "%K{001} %F{000}/tmp %k%F{001}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testDynamicColoringOfVisualIdentifiersWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON_COLOR='green'
  local P9K_DIR_DEFAULT_ICON="icon-here"
  source segments/dir.p9k

  cd /tmp

  assertEquals "%K{004} %F{002}icon-here %f%F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON_COLOR='green'
  local P9K_DIR_DEFAULT_FOREGROUND='red'
  local P9K_DIR_DEFAULT_BACKGROUND='yellow'
  local P9K_DIR_DEFAULT_ICON="icon-here"
  source segments/dir.p9k

  # Re-Source the icons, as the P9K_MODE is directly
  # evaluated there.
  source functions/icons.zsh

  cd /tmp

  assertEquals "%K{003} %F{002}icon-here %f%F{001}/tmp %k%F{003}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testOverwritingIconsWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON='icon-here'
  source segments/dir.p9k
  #local testFolder=$(mktemp -d -p p9k)
  # Move testFolder under home folder
  #mv testFolder ~
  # Go into testFolder
  #cd ~/$testFolder

  cd /tmp
  assertEquals "%K{004} %F{000}icon-here %f%F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  # rm -fr ~/$testFolder
}

function testNewlineOnRpromptCanBeDisabled() {
  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_RPROMPT_ON_NEWLINE=false
  local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"
  local P9K_CUSTOM_RWORLD='echo rworld'
  p9k::register_segment "RWORLD"
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local P9K_RIGHT_PROMPT_ELEMENTS=(custom_rworld)

  __p9k_prepare_prompts
  #             ╭─[39m[0m[49m[107m [30mworld [49m[97m[39m  ╰─ [1A[39m[0m[49m[97m[107m[30m rworld [30m [00m[1B
  assertEquals '╭─[39m[0m[49m[107m [30mworld [49m[97m[39m  ╰─ [1A[39m[0m[49m[97m[107m[30m rworld [30m [00m[1B' "$(print -P ${PROMPT}${RPROMPT})"

}

source shunit2/shunit2
