#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  source test/helper/build_prompt_wrapper.sh
}

function testAnacondaSegmentPrintsNothingIfNoAnacondaPathIsSet() {
  local P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(anaconda world::custom)
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  # Unset anacona variables
  unset CONDA_ENV_PATH
  unset CONDA_PREFIX

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testAnacondaSegmentWorksIfOnlyAnacondaPathIsSet() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(anaconda)
  local P9K_ANACONDA_ICON="icon-here"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  CONDA_ENV_PATH=/tmp
  unset CONDA_PREFIX

  assertEquals "%K{004} %F{000}icon-here %F{000}(tmp) %k%F{004}%f " "$(__p9k_build_left_prompt)"
}

function testAnacondaSegmentWorksIfOnlyAnacondaPrefixIsSet() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(anaconda)
  local P9K_ANACONDA_ICON="icon-here"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  unset CONDA_ENV_PATH
  local CONDA_PREFIX="test"

  assertEquals "%K{004} %F{000}icon-here %F{000}(test) %k%F{004}%f " "$(__p9k_build_left_prompt)"
}

function testAnacondaSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(anaconda)
  local P9K_ANACONDA_ICON="icon-here"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  local CONDA_ENV_PATH=/tmp
  local CONDA_PREFIX="test"

  assertEquals "%K{004} %F{000}icon-here %F{000}(tmptest) %k%F{004}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2
