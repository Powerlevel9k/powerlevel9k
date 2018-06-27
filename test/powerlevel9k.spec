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
  P9K_LEFT_PROMPT_ELEMENTS=(dir dir_joined)
  cd /tmp

  assertEquals "%K{blue} %F{black}/tmp %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  cd -
}

function testTransitiveJoinedSegments() {
  P9K_LEFT_PROMPT_ELEMENTS=(dir root_indicator_joined dir_joined)
  cd /tmp

  assertEquals "%K{blue} %F{black}/tmp %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  cd -
}

function testJoiningWithConditionalSegment() {
  P9K_LEFT_PROMPT_ELEMENTS=(dir background_jobs dir_joined)
  cd /tmp

  assertEquals "%K{blue} %F{black}/tmp  %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  cd -
}

function testDynamicColoringOfSegmentsWork() {
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  P9K_DIR_DEFAULT_BACKGROUND='red'
  cd /tmp

  assertEquals "%K{red} %F{black}/tmp %k%F{red}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_DIR_DEFAULT_BACKGROUND
  cd -
}

function testDynamicColoringOfVisualIdentifiersWork() {
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  P9K_DIR_DEFAULT_ICON="*icon-here"
  P9K_DIR_DEFAULT_ICON_COLOR='green'

  cd /tmp

  assertEquals "%K{blue} %F{green}*icon-here %f%F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_DIR_DEFAULT_ICON
  unset P9K_DIR_DEFAULT_ICON_COLOR
  cd -
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  P9K_DIR_DEFAULT_FOREGROUND='red'
  P9K_DIR_DEFAULT_BACKGROUND='yellow'
  P9K_DIR_DEFAULT_ICON="*icon-here"
  P9K_DIR_DEFAULT_ICON_COLOR='green'

  # Re-Source the icons, as the P9K_MODE is directly
  # evaluated there.
  source functions/icons.zsh

  cd /tmp

  assertEquals "%K{yellow} %F{green}*icon-here %f%F{red}/tmp %k%F{yellow}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_DIR_DEFAULT_FOREGROUND
  unset P9K_DIR_DEFAULT_BACKGROUND
  unset P9K_DIR_DEFAULT_ICON
  unset P9K_DIR_DEFAULT_ICON_COLOR
  cd -
}

function testOverwritingIconsWork() {
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  P9K_DIR_DEFAULT_ICON='*icon-here'
  #local testFolder=$(mktemp -d -p p9k)
  # Move testFolder under home folder
  #mv testFolder ~
  # Go into testFolder
  #cd ~/$testFolder

  cd /tmp
  assertEquals "%K{blue} %F{black}*icon-here %f%F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_DIR_FOLDER_ICON
  cd -
  # rm -fr ~/$testFolder
}

function testNewlineOnRpromptCanBeDisabled() {
  P9K_PROMPT_ON_NEWLINE=true
  P9K_RPROMPT_ON_NEWLINE=false
  P9K_CUSTOM_WORLD='echo world'
  P9K_CUSTOM_RWORLD='echo rworld'
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world)
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_rworld)

  p9kPreparePrompts
  assertEquals '$(printIcon MULTILINE_FIRST_PROMPT_PREFIX)[39m[0m[49m[47m [30mworld [49m[37m[39m  $(printIcon MULTILINE_LAST_PROMPT_PREFIX)[1A[39m[0m[49m[37m[39m[47m[30m rworld [39m[00m[1B' "$(print -P ${PROMPT}${RPROMPT})"

  unset P9K_PROMPT_ON_NEWLINE
  unset P9K_RPROMPT_ON_NEWLINE
  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_RIGHT_PROMPT_ELEMENTS
  unset P9K_CUSTOM_WORLD
  unset P9K_CUSTOM_RWORLD

}

source shunit2/source/2.1/src/shunit2
