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

function mockStackVersion() {
  case "$1" in
    "--version")
      echo "Version 1.7.1, Git revision 681c800873816c022739ca7ed14755e85a579565 (5807 commits) x86_64 hpack-0.28.2"
      ;;
    default)
  esac
}

function mockUpsearchStackYaml() {
  case "$1" in
    "stack.yaml")
      echo "/home/MockProject"
      ;;
    default)
  esac
}

function mockUpsearchNoStackYaml() {
  case "$1" in
    "stack.yaml")
      echo $HOME
      ;;
    default)
  esac
}

function mockNoStackVersion() {
  # This should output some error
  echo "Stack does not seem to be present"
  return 1
}

function testStackProjectSegment() {
  alias stack=mockStackVersion
  P9K_HASKELL_ICON='x'
  P9K_LEFT_PROMPT_ELEMENTS=(stack_project)

  assertEquals "%K{purple3} %F{white%}x %f%F{white}Stack %k%F{purple3}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_HASKELL_ICON
  unalias stack
}

function testStackProjectSegmentNoStackYaml() {
  alias stack=mockStackVersion
  alias __p9k_upsearch=mockUpsearchNoStackYaml

  P9K_CUSTOM_WORLD='echo world'
  P9K_HASKELL_ICON='x'
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world stack_project)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_HASKELL_ICON
  unset P9K_CUSTOM_WORLD
  unalias stack
  unalias __p9k_upsearch
}

function testStackProjectSegmentIfStackIsNotAvailable() {
  alias stack=mockNoStackVersion
  P9K_CUSTOM_WORLD='echo world'
  P9K_HASKELL_ICON='x'
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world stack_project)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_HASKELL_ICON
  unset P9K_CUSTOM_WORLD
  unalias stack
}

function testStackProjectSegmentPrintsNothingIfStackIsNotAvailable() {
  alias stack=noStack
  P9K_CUSTOM_WORLD='echo world'
  P9K_HASKELL_ICON='x'
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world stack_project)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_HASKELL_ICON
  unset P9K_CUSTOM_WORLD
  unalias stack
}

source shunit2/shunit2