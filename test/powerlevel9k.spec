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

  # Unset mode, so that user settings
  # do not interfere with tests
  unset P9K_MODE

  # Load all segments that need to be tested so that they can be sourced
  P9K_LEFT_PROMPT_ELEMENTS=(dir root_indicator background_jobs)
}

function testJoinedSegments() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir dir_joined)
  cd /tmp

  assertEquals "%K{blue} %F{black}/tmp %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testTransitiveJoinedSegments() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir root_indicator_joined dir_joined)
  cd /tmp

  assertEquals "%K{blue} %F{black}/tmp %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testJoiningWithConditionalSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir background_jobs dir_joined)
  cd /tmp

  assertEquals "%K{blue} %F{black}/tmp  %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testDynamicColoringOfSegmentsWork() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_BACKGROUND='red'
  cd /tmp

  assertEquals "%K{red} %F{black}/tmp %k%F{red}%f " "$(buildLeftPrompt)"

  cd -
}

function testDynamicColoringOfVisualIdentifiersWork() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON="*icon-here"
  local P9K_DIR_DEFAULT_ICON_COLOR='green'

  cd /tmp

  assertEquals "%K{blue} %F{green}*icon-here %f%F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_FOREGROUND='red'
  local P9K_DIR_DEFAULT_BACKGROUND='yellow'
  local P9K_DIR_DEFAULT_ICON="*icon-here"
  local P9K_DIR_DEFAULT_ICON_COLOR='green'

  # Re-Source the icons, as the P9K_MODE is directly
  # evaluated there.
  source functions/icons.zsh

  cd /tmp

  assertEquals "%K{yellow} %F{green}*icon-here %f%F{red}/tmp %k%F{yellow}%f " "$(buildLeftPrompt)"

  cd -
}

function testOverwritingIconsWork() {
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON='*icon-here'
  #local testFolder=$(mktemp -d -p p9k)
  # Move testFolder under home folder
  #mv testFolder ~
  # Go into testFolder
  #cd ~/$testFolder

  cd /tmp
  assertEquals "%K{blue} %F{black}*icon-here %f%F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  # rm -fr ~/$testFolder
}

# ANSI escape sequences
# %b - [0m  - bold off
# %F - [3_m - set foreground color
# %f - [39m - default foreground color
# %K - [4_m - set background color
# %k - [49m - default background color
#      [_A  - cursor up
#      [_B  - cursor down

function testNewlineOnRpromptCanBeDisabled() {
  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_RPROMPT_ON_NEWLINE=false
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_CUSTOM_RWORLD='echo rworld'
  registerSegment "RWORLD"
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
  local P9K_RIGHT_PROMPT_ELEMENTS=(custom_rworld)

  p9kPreparePrompts
  #╭─\^[[39m^[[0m^[[49m^[[47m ^[[30mworld ^[[49m^[[37m^[[39m  ╰─ ^[[1A^[[39m^[[0m^[[49m^[[37m^[[47m^[[30m rworld^[[30m ^[[00m^[[1B>
  assertEquals '╭─[39m[0m[49m[47m [30mworld [49m[37m[39m  ╰─ [1A[39m[0m[49m[37m[47m[30m rworld[30m [00m[1B' "$(print -P ${PROMPT}${RPROMPT})"
}

source shunit2/source/2.1/src/shunit2
