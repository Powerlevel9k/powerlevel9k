#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test
  mkdir -p "${FOLDER}"
  cd $FOLDER

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme
  source ${P9K_HOME}/segments/swift_version.p9k
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
}

function testSwiftSegmentPrintsNothingIfSwiftIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(swift_version custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"
  alias swift="noswift"

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias swift
}

function testSwiftSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(swift_version)
  function swift() {
    echo "Apple Swift version 3.0.1 (swiftlang-800.0.58.6 clang-800.0.42.1)\nTarget: x86_64-apple-macosx10.9"
  }

  assertEquals "%K{005} %F{015}Swift %f%F{015}3.0.1 %k%F{005}%f " "$(__p9k_build_left_prompt)"

  unfunction swift
}

source shunit2/shunit2
