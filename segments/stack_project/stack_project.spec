#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Backing up P9K_MODE and setting it to default
  BACKUP_P9K_MODE=$P9K_MODE
  P9K_MODE=default
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  # Load Stack project segment
  source segments/stack_project/stack_project.p9k
}

function tearDown(){
  # Resetting P9K_MODE to its previous value
  P9K_MODE=$BACKUP_P9K_MODE
}

function mockStackVersion() {
  case "$1" in
    "--version")
      echo "Version 1.7.1 x86_64"
      ;;
    default)
  esac
}

function mockUpsearchStackYaml() {
  case "$1" in
    "stack.yaml")
      echo "/home\n/home/MockProject"
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
  return 0
}

function testStackProjectSegment() {
  alias stack=mockStackVersion
  alias __p9k_upsearch=mockUpsearchStackYaml
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(stack_project)

  assertEquals "%K{056} %F{015}λ=%f %F{015}Stack %k%F{056}%f " "$(__p9k_build_left_prompt)"

  unalias stack
}

function testStackProjectSegmentNoStackYaml() {
  alias stack=mockStackVersion
  alias __p9k_upsearch=mockUpsearchNoStackYaml

  local P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom stack_project)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias stack
  unalias __p9k_upsearch
}

function testStackProjectSegmentIfStackIsNotAvailable() {
  alias stack=mockNoStackVersion
  local P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom stack_project)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias stack
}

function testStackProjectSegmentPrintsNothingIfStackIsNotAvailable() {
  alias stack=noStack
  local P9K_CUSTOM_WORLD='echo world'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom stack_project)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias stack
}

source shunit2/shunit2
