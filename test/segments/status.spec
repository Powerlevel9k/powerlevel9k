#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/status.p9k

  ### Test specific
  # Resets if someone has set these in his/hers env
  unset P9K_STATUS_VERBOSE
  unset P9K_STATUS_OK_IN_NON_VERBOSE
}

function testStatusPrintsNothingIfReturnCodeIsZeroAndVerboseIsUnset() {
    local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"
    local P9K_LEFT_PROMPT_ELEMENTS=(status custom_world)
    local P9K_STATUS_VERBOSE=false
    local P9K_STATUS_SHOW_PIPESTATUS=false

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"
}

function testStatusWorksAsExpectedIfReturnCodeIsZeroAndVerboseIsSet() {
    local P9K_STATUS_VERBOSE=true
    local P9K_STATUS_SHOW_PIPESTATUS=false
    local P9K_STATUS_HIDE_SIGNAME=true
    local P9K_LEFT_PROMPT_ELEMENTS=(status)

    assertEquals "%K{black} %F{green}✔ %f%F{green}%k%F{black}%f " "$(__p9k_build_left_prompt)"
}

function testStatusInGeneralErrorCase() {
    local RETVAL=1
    local P9K_LEFT_PROMPT_ELEMENTS=(status)
    local P9K_STATUS_VERBOSE=true
    local P9K_STATUS_SHOW_PIPESTATUS=false

    assertEquals "%K{red} %F{yellow1}↵ %f%F{yellow1}1 %k%F{red}%f " "$(__p9k_build_left_prompt)"
}

function testPipestatusInErrorCase() {
    local -a RETVALS
    RETVALS=(0 0 1 0)
    local P9K_LEFT_PROMPT_ELEMENTS=(status)
    local P9K_STATUS_VERBOSE=true
    local P9K_STATUS_SHOW_PIPESTATUS=true

    assertEquals "%K{red} %F{yellow1}↵ %f%F{yellow1}0|0|1|0 %k%F{red}%f " "$(__p9k_build_left_prompt)"
}

function testStatusCrossWinsOverVerbose() {
    local RETVAL=1
    local P9K_LEFT_PROMPT_ELEMENTS=(status)
    local P9K_STATUS_SHOW_PIPESTATUS=false
    local P9K_STATUS_VERBOSE=true
    local P9K_STATUS_CROSS=true

    assertEquals "%K{black} %F{red}✘ %f%F{red}%k%F{black}%f " "$(__p9k_build_left_prompt)"
}

function testStatusShowsSignalNameInErrorCase() {
    local RETVAL=132
    local P9K_LEFT_PROMPT_ELEMENTS=(status)
    local P9K_STATUS_SHOW_PIPESTATUS=false
    local P9K_STATUS_VERBOSE=true
    local P9K_STATUS_HIDE_SIGNAME=false

    assertEquals "%K{red} %F{yellow1}↵ %f%F{yellow1}SIGILL(4) %k%F{red}%f " "$(__p9k_build_left_prompt)"
}

function testStatusSegmentIntegrated() {
    local P9K_LEFT_PROMPT_ELEMENTS=(status)
    local P9K_RIGHT_PROMPT_ELEMENTS=()

    false; __p9k_prepare_prompts

    assertEquals "%f%b%k%K{black} %F{red}✘ %f%F{red}%k%F{black}%f " "${(e)PROMPT}"
}

source shunit2/source/2.1/src/shunit2
