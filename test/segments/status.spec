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
  source segments/status.p9k

  ### Test specific
  # Resets if someone has set these in his/hers env
  unset P9K_STATUS_VERBOSE
  unset P9K_STATUS_OK_IN_NON_VERBOSE
  }

function testStatusPrintsNothingIfReturnCodeIsZeroAndVerboseIsUnset() {
  local P9K_CUSTOM_WORLD='echo world'
  local P9K_LEFT_PROMPT_ELEMENTS=(status custom_world)
  local P9K_STATUS_VERBOSE=false
  local P9K_STATUS_SHOW_PIPESTATUS=false

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
  samplePerformanceSilent "Status None" __p9k_build_left_prompt
}

function testStatusWorksAsExpectedIfReturnCodeIsZeroAndVerboseIsSet() {
  local P9K_STATUS_VERBOSE=true
  local P9K_STATUS_SHOW_PIPESTATUS=false
  local P9K_STATUS_HIDE_SIGNAME=true
  local P9K_LEFT_PROMPT_ELEMENTS=(status)

  assertEquals "%K{000} %F{002}✔ %f%F{002}%k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testStatusInGeneralErrorCase() {
  local RETVAL=1
  local P9K_LEFT_PROMPT_ELEMENTS=(status)
  local P9K_STATUS_VERBOSE=true
  local P9K_STATUS_SHOW_PIPESTATUS=false

  assertEquals "%K{001} %F{226}↵ %f%F{226}1 %k%F{001}%f " "$(__p9k_build_left_prompt)"
  samplePerformanceSilent "Status Error" __p9k_build_left_prompt
}

function testPipestatusInErrorCase() {
  local -a RETVALS
  RETVALS=(0 0 1 0)
  local P9K_LEFT_PROMPT_ELEMENTS=(status)
  local P9K_STATUS_VERBOSE=true
  local P9K_STATUS_SHOW_PIPESTATUS=true

  assertEquals "%K{001} %F{226}↵ %f%F{226}0|0|1|0 %k%F{001}%f " "$(__p9k_build_left_prompt)"
}

function testStatusCrossWinsOverVerbose() {
  local RETVAL=1
  local P9K_LEFT_PROMPT_ELEMENTS=(status)
  local P9K_STATUS_SHOW_PIPESTATUS=false
  local P9K_STATUS_VERBOSE=true
  local P9K_STATUS_CROSS=true

  assertEquals "%K{000} %F{001}✘ %f%F{001}%k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testStatusShowsSignalNameInErrorCase() {
  local RETVAL=132
  local P9K_LEFT_PROMPT_ELEMENTS=(status)
  local P9K_STATUS_SHOW_PIPESTATUS=false
  local P9K_STATUS_VERBOSE=true
  local P9K_STATUS_HIDE_SIGNAME=false

  assertEquals "%K{001} %F{226}↵ %f%F{226}SIGILL(4) %k%F{001}%f " "$(__p9k_build_left_prompt)"
  samplePerformanceSilent "Status Signal" __p9k_build_left_prompt
}

function testStatusSegmentIntegrated() {
  local P9K_LEFT_PROMPT_ELEMENTS=(status)
  local P9K_RIGHT_PROMPT_ELEMENTS=()

  false; __p9k_prepare_prompts

  assertEquals "%f%b%k%K{000} %F{001}✘ %f%F{001}%k%F{000}%f " "${(e)PROMPT}"
}

source shunit2/shunit2
