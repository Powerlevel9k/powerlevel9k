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

function testCondaSegmentWithNewlineInPath() {
  local CONDA_ENV_PATH="C:\app\anaconda3\lib\site-packages\newton\conda\cli"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  assertEquals "%K{blue} %F{black}(C:appanaconda3libsite-packagesnewtoncondacli) %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_ENV_PATH
}

function testCondaSegmentWithCarriageReturnInPath() {
  local CONDA_ENV_PATH="C:\app\anaconda3\lib\site-packages\redmond\conda\cli"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  assertEquals "%K{blue} %F{black}(C:appanaconda3libsite-packagesredmondcondacli) %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_ENV_PATH
}

function testCondaSegmentWithNewlineAndCarriageReturnInPath() {
  local CONDA_ENV_PATH="C:\app\anaconda3\lib\site-packages\newton\redmond\conda\cli"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  assertEquals "%K{blue} %F{black}(C:appanaconda3libsite-packagesnewtonredmondcondacli) %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_ENV_PATH
}

function testCondaSegmentWithCarriageReturnAndNewlineInPath() {
  local CONDA_ENV_PATH="C:\app\anaconda3\lib\site-packages\redmond\newton\conda\cli"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  assertEquals "%K{blue} %F{black}(C:appanaconda3libsite-packagesredmondnewtoncondacli) %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_ENV_PATH
}

function testCondaSegmentWithCarriageReturnNewlineBellAndTabInPath() {
  local CONDA_ENV_PATH="C:\app\anaconda3\lib\t\a\n\site-packages\redmond\newton\conda\cli"
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda)

  assertEquals "%K{blue} %F{black}(C:appanaconda3libtansite-packagesredmondnewtoncondacli) %k%F{blue}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset CONDA_ENV_PATH
}

source shunit2/source/2.1/src/shunit2
