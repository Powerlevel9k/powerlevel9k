#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()

  # Test specfic
  source test/helper/build_prompt_wrapper.sh
  # unset all possible user specified variables
  unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
  unset NODE_VIRTUAL_ENV
}

function testNodeenvSegmentPrintsNothingWithoutNode() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(nodeenv world::custom)
  local P9K_CUSTOM_WORLD='echo world'
  alias node="nonode 2>/dev/null"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvIsNotSet() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(nodeenv world::custom)
  local P9K_CUSTOM_WORLD='echo world'
  node() {
    echo "v1.2.3"
  }

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unfunction node
}

function testNodeenvSegmentPrintsAtLeastNodeEnvWithoutNode() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(nodeenv)
  alias node="nonode 2>/dev/null"
  NODE_VIRTUAL_ENV="node-env"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  assertEquals "%K{000} %F{002}⬢ %F{002}[node-env] %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unset NODE_VIRTUAL_ENV
  unalias node
}

function testNodeenvSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(nodeenv)
  node() {
    echo "v1.2.3"
  }
  NODE_VIRTUAL_ENV="node-env"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  assertEquals "%K{000} %F{002}⬢ %F{002}v1.2.3[node-env] %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction node
  unset NODE_VIRTUAL_ENV
}

source shunit2/shunit2
