#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  P9K_HOME=$(pwd)
  ### Test specific
}

function testNewlineDoesNotCreateExtraSegmentSeparator() {
    local P9K_CUSTOM_WORLD1="echo world1"
    local P9K_CUSTOM_WORLD2="echo world2"
    local -a P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 newline newline newline custom_world2)

    # Load Powerlevel9k
    source ${P9K_HOME}/powerlevel9k.zsh-theme
    local OS="OSX" # Fake OSX

    local newline=$'\n'

    assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}} %k%F{015}\${(Q)\${:-\"${newline}\"}}%k \${(Q)\${:-\"${newline}\"}}%k \${(Q)\${:-\"${newline}\"}}%K{015} %F{000}\${(Q)\${:-\"world2\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testNewlineMakesPreviousSegmentEndWell() {
    local P9K_CUSTOM_WORLD1="echo world1"
    local -a P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 newline)

    # Load Powerlevel9k
    source ${P9K_HOME}/powerlevel9k.zsh-theme
    local OS="OSX" # Fake OSX

    local newline=$'\n'

    assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}} %k%F{015}\${(Q)\${:-\"${newline}\"}}%k%FNONE%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2