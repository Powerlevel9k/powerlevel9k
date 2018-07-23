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

function mockNoStackVersion() {
  # This should output some error
  >&2 echo "Stack does not seem to be present"
  return 1
}

function testStackProjectSegment() {
  alias stack=mockStackVersion
  POWERLEVEL9K_HASKELL_ICON='x'
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(stack_project)

  assertEquals "%K{005} %F{white%}x %f%F{white}Stack 1.7.1 %k%F{purple}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset POWERLEVEL9K_HASKELL_ICON
  unalias stack
}

function testStackProjectSegmentIfStackIsNotAvailable() {
  alias stack=mockNoStackVersion
  POWERLEVEL9K_CUSTOM_WORLD='echo world'
  POWERLEVEL9K_HASKELL_ICON='x'
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_world stack_project)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset POWERLEVEL9K_HASKELL_ICON
  unset POWERLEVEL9K_CUSTOM_WORLD
  unalias stack
}

function testStackProjectSegmentPrintsNothingIfStackIsNotAvailable() {
  alias stack=noStack
  POWERLEVEL9K_CUSTOM_WORLD='echo world'
  POWERLEVEL9K_HASKELL_ICON='x'
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_world stack_project)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(build_left_prompt)"

  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset POWERLEVEL9K_HASKELL_ICON
  unset POWERLEVEL9K_CUSTOM_WORLD
  unalias stack
}

source shunit2/source/2.1/src/shunit2