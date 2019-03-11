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
  source segments/node_version/node_version.p9k
}

function testNodeVersionSegmentPrintsNothingWithoutNode() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(node_version custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  alias node="nonode 2>/dev/null"

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias node
}

function testNodeVersionSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(node_version)
  node() {
    echo "v1.2.3"
  }

  assertEquals "%K{002} %F{015}⬢ %F{015}1.2.3 %k%F{002}%f " "$(__p9k_build_left_prompt)"

  unfunction node
}

source shunit2/shunit2
