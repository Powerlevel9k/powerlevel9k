#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testConda() {
  local CONDA_PREFIX="conda"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  assertEquals "%K{blue} %F{black}(conda) %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_PREFIX
}

function testCondaSegmentWithWindowsPath() {
  local CONDA_ENV_PATH="C:\app\anaconda3\lib\site-packages\newton\conda\cli"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  # Careful! This string contains special characters! Look with hexdump or similar.
  assertEquals "%K{blue} %F{black}(C:ppnaconda3\lib\site-packagesewton %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_ENV_PATH
}

source shunit2/source/2.1/src/shunit2
