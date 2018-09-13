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
}

function tearDown() {
  # Restore old variables
  [[ -n "$OLD_DEFAULT_USER" ]] && DEFAULT_USER=$OLD_DEFAULT_USER

  return 0
}

function testContextSegmentDoesNotGetRenderedWithDefaultUser() {
    local DEFAULT_USER=$(whoami)
    local P9K_CUSTOM_WORLD='echo world'
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context custom_world)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{007} %F{000}world %k%F{007}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentDoesGetRenderedWhenSshConnectionIsOpen() {
    function sudo() {
        return 0
    }
    local SSH_CLIENT="putty"
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"

    unfunction sudo
}

function testContextSegmentWithForeignUser() {
    function sudo() {
        return 0
    }
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"

    unfunction sudo
}

# TODO: How to test root?
function testContextSegmentWithRootUser() {
    startSkipping # Skip test
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testOverridingContextTemplate() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)
    local P9K_CONTEXT_TEMPLATE=xx

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{003}xx %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentIsShownIfDefaultUserIsSetWhenForced() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)
    local P9K_ALWAYS_SHOW_CONTEXT=true
    local DEFAULT_USER=$(whoami)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{003}%n@%m %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

function testContextSegmentIsShownIfForced() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)
    local P9K_ALWAYS_SHOW_USER=true
    local DEFAULT_USER=$(whoami)

    # Load Powerlevel9k
    source powerlevel9k.zsh-theme

    assertEquals "%K{000} %F{003}$(whoami) %k%F{000}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2