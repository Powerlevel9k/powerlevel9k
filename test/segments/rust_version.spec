#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

TEST_BASE_FOLDER=/tmp/powerlevel9k-test
RUST_TEST_FOLDER="${TEST_BASE_FOLDER}/rust-test"

function setUp() {
  OLDPATH="${PATH}"
  mkdir -p "${RUST_TEST_FOLDER}"
  PATH="${RUST_TEST_FOLDER}:${PATH}"

  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/rust_version.p9k
}

function tearDown() {
  PATH="${OLDPATH}"
  rm -fr "${TEST_BASE_FOLDER}"
}

function mockRust() {
  echo "#!/bin/sh\n\necho 'rustc 0.4.1a-alpha'" > "${RUST_TEST_FOLDER}/rustc"
  chmod +x "${RUST_TEST_FOLDER}/rustc"
}

function testRust() {
  mockRust
  local P9K_LEFT_PROMPT_ELEMENTS=(rust_version)

  assertEquals "%K{208} %F{black}Rust %f%F{black}0.4.1a-alpha %k%F{208}%f " "$(buildLeftPrompt)"
}

function testRustPrintsNothingIfRustIsNotAvailable() {
  local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
  local P9K_LEFT_PROMPT_ELEMENTS=(custom_world rust_version)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

source shunit2/source/2.1/src/shunit2
