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

function mockRust() {
  echo 'rustc  0.4.1a-alpha'
}

function testRust() {
  alias rustc=mockRust
  P9K_LEFT_PROMPT_ELEMENTS=(rust_version)

  assertEquals "%K{208} %F{black}Rust 0.4.1a-alpha %k%F{darkorange}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unalias rustc
}

function testRustPrintsNothingIfRustIsNotAvailable() {
  alias rustc=noRust
  P9K_CUSTOM_WORLD='echo world'
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world rust_version)

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_CUSTOM_WORLD
  unalias rustc
}

source shunit2/source/2.1/src/shunit2
