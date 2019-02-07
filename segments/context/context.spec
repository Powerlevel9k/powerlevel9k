#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  
  # Test specific settings
  OLD_DEFAULT_USER=$DEFAULT_USER
  unset DEFAULT_USER

  # Fix leaked state for travis
  OLD_P9K_CONTEXT_ALWAYS_SHOW=$P9K_CONTEXT_ALWAYS_SHOW
  unset P9K_CONTEXT_ALWAYS_SHOW
  OLD_SSH_CLIENT=$SSH_CLIENT
  unset SSH_CLIENT
  OLD_SSH_TTY=$SSH_TTY
  unset SSH_TTY

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/context/context.p9k
}

function tearDown() {
  # Restore old variables
  [[ -n "$OLD_DEFAULT_USER" ]] && DEFAULT_USER=$OLD_DEFAULT_USER
  unset OLD_DEFAULT_USER

  [[ -n "$OLD_P9K_CONTEXT_ALWAYS_SHOW" ]] && P9K_CONTEXT_ALWAYS_SHOW=$OLD_P9K_CONTEXT_ALWAYS_SHOW
  unset OLD_P9K_CONTEXT_ALWAYS_SHOW

  [[ -n "$OLD_SSH_CLIENT" ]] && SSH_CLIENT=$OLD_SSH_CLIENT
  unset OLD_SSH_CLIENT

  [[ -n "$OLD_SSH_TTY" ]] && SSH_TTY=$OLD_SSH_TTY
  unset OLD_SSH_TTY
}

function testContextSegmentDoesNotGetRenderedWithDefaultUser() {
  local DEFAULT_USER=$(whoami)
  local P9K_CUSTOM_WORLD='echo world'
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
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)

  assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentWithRootUser() {
  local SUDO_COMMAND="sudo"
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)

  assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testOverridingContextTemplate() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)
  local P9K_CONTEXT_TEMPLATE=xx
  local P9K_CONTEXT_TEMPLATE_DEFAULT_USER=zz

  assertEquals "%K{000} %F{003}xx %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testOverridingContextTemplateForDefaultUser() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(context)
  local P9K_CONTEXT_TEMPLATE=zz
  local P9K_CONTEXT_TEMPLATE_DEFAULT_USER=xx
  local P9K_CONTEXT_ALWAYS_SHOW=true
  local DEFAULT_USER=$(whoami)

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
