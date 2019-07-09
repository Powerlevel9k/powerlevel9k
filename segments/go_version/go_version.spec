#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()

  source test/helper/build_prompt_wrapper.sh
}

function mockGo() {
  case "$1" in
  'version')
    echo 'go version go1.5.3 darwin/amd64'
    ;;
  'env')
    echo "$HOME/go"
    ;;
  esac
}

function mockGoEmptyGopath() {
  case "$1" in
  'version')
    echo 'go version go1.5.3 darwin/amd64'
    ;;
  'env')
    echo ""
    ;;
  esac
}

function testGo() {
  alias go=mockGo
  P9K_GO_VERSION_ICON="icon-here"
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(go_version)

  PWD="$HOME/go/src/github.com/bhilburn/powerlevel9k"

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/go_version/go_version.p9k

  assertEquals "%K{002} %F{255}icon-here %F{255}go1.5.3 %k%F{002}%f " "$(__p9k_build_left_prompt)"

  unset P9K_GO_ICON
  unset PWD
  unset P9K_LEFT_PROMPT_ELEMENTS
  unalias go
}

function testGoSegmentPrintsNothingIfEmptyGopath() {
  alias go=mockGoEmptyGopath
  P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom go_version)

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/go_version/go_version.p9k

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_CUSTOM_WORLD

}

function testGoSegmentPrintsNothingIfNotInGopath() {
  alias go=mockGo
  P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom go_version)

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/go_version/go_version.p9k

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_CUSTOM_WORLD
}

function testGoSegmentPrintsNothingIfGoIsNotAvailable() {
  alias go=noGo
  P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom go_version)

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/go_version/go_version.p9k

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_CUSTOM_WORLD
  unalias go
}

source shunit2/shunit2
