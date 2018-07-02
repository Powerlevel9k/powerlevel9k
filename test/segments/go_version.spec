#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/go_version.p9k
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
  local P9K_GO_VERSION_ICON=""
  local P9K_LEFT_PROMPT_ELEMENTS=(go_version)
  source segments/go_version.p9k

  local PWD="$HOME/go/src/github.com/bhilburn/powerlevel9k"

  assertEquals "%K{green} %F{grey93} %f%F{grey93}go1.5.3 %k%F{green}%f " "$(buildLeftPrompt)"

  unalias go
}

function testGoSegmentPrintsNothingIfEmptyGopath() {
  alias go=mockGoEmptyGopath
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world go_version)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testGoSegmentPrintsNothingIfNotInGopath() {
  alias go=mockGo
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world go_version)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testGoSegmentPrintsNothingIfGoIsNotAvailable() {
  alias go=noGo
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world go_version)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
  unalias go
}

source shunit2/source/2.1/src/shunit2
