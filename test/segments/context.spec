#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  # Test specific settings
  OLD_DEFAULT_USER=$DEFAULT_USER
  unset DEFAULT_USER

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/context.p9k
}

function tearDown() {
  # Restore old variables
  [[ -n "$OLD_DEFAULT_USER" ]] && DEFAULT_USER=$OLD_DEFAULT_USER
  unset OLD_DEFAULT_USER
}

function testContextSegmentDoesNotGetRenderedWithDefaultUser() {
  local DEFAULT_USER=$(whoami)
  local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context custom_world)

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentDoesGetRenderedWhenSshConnectionIsOpen() {
  local SSH_CLIENT="putty"
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)

  assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentWithForeignUser() {
  function sudo() {
    return 0
  }
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)

  assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction sudo
}

# TODO: How to test root?
function testContextSegmentWithRootUser() {
  startSkipping # Skip test
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)

  assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testOverridingContextTemplate() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)
  local P9K_CONTEXT_TEMPLATE=xx

  assertEquals "%K{000} %F{003}xx %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentIsShownIfDefaultUserIsSetWhenForced() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)
  local P9K_CONTEXT_ALWAYS_SHOW=true
  local DEFAULT_USER=$(whoami)

  assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentIsShownIfForced() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)
  local P9K_CONTEXT_ALWAYS_SHOW_USER=true
  local DEFAULT_USER=$(whoami)

  assertEquals "%K{000} %F{003}$(whoami) %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2
