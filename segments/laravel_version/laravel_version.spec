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
}

function mockLaravelVersion() {
  case "$1" in
    "artisan")
      echo "Laravel Framework 5.4.23"
      ;;
    default)
  esac
}

function mockNoLaravelVersion() {
  # When php can't find a file it will output a message
  echo "Could not open input file: artisan"
  return 0
}

function testLaravelVersionSegment() {
  alias php=mockLaravelVersion
  local P9K_LARAVEL_VERSION_ICON='x'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(laravel_version)
  source segments/laravel_version/laravel_version.p9k

  assertEquals "%K{001} %F{015}x %F{015}\${(Q)\${:-\"5.4.23\"}} %k%F{001}%f " "$(__p9k_build_left_prompt)"
  unalias php
}

function testLaravelVersionSegmentIfArtisanIsNotAvailable() {
  alias php=mockNoLaravelVersion
  local P9K_CUSTOM_WORLD='echo world'
  local P9K_LARAVEL_VERSION_ICON='x'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world laravel_version)
  source segments/laravel_version/laravel_version.p9k

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias php
}

function testLaravelVersionSegmentPrintsNothingIfPhpIsNotAvailable() {
  alias php=noPhp
  local P9K_CUSTOM_WORLD='echo world'
  local P9K_LARAVEL_VERSION_ICON='x'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world laravel_version)
  source segments/laravel_version/laravel_version.p9k

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias php
}

source shunit2/shunit2
