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

function mockLaravelVersion() {
  case "$1" in
    "artisan")
      echo "Laravel Framework version 5.4.23"
      ;;
    default)
  esac
}

function mockNoLaravelVersion() {
  # This should output some error
  >&2 echo "Artisan not available"
  return 1
}

function testLaravelVersionSegment() {
  alias php=mockLaravelVersion
  local P9K_LARAVEL_VERSION_ICON='*x'
  local P9K_LEFT_PROMPT_ELEMENTS=(laravel_version)
  source segments/laravel_version.p9k

  assertEquals "%K{001} %F{white}*x %f%F{white}5.4.23 %k%F{001}%f " "$(buildLeftPrompt)"

  unalias php
}

function testLaravelVersionSegmentIfArtisanIsNotAvailable() {
  alias php=mockNoLaravelVersion
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_LARAVEL_VERSION_ICON='*x'
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world laravel_version)
  source segments/laravel_version.p9k

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

  unalias php
}

function testLaravelVersionSegmentPrintsNothingIfPhpIsNotAvailable() {
  alias php=noPhp
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_LARAVEL_VERSION_ICON='*x'
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world laravel_version)
  source segments/laravel_version.p9k

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

  unalias php
}

source shunit2/source/2.1/src/shunit2
