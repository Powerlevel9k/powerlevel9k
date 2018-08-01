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
}

function testContextSegmentDoesNotGetRenderedWithDefaultUser() {
    local DEFAULT_USER=$(whoami)
    local P9K_CUSTOM_WORLD='echo world'
  registerSegment "WORLD"
    registerSegment "WORLD"
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context custom_world)

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(buildLeftPrompt)"
}

function testContextSegmentDoesGetRenderedWhenSshConnectionIsOpen() {
    local SSH_CLIENT="putty"
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)

    assertEquals "%K{black} %F{yellow}%n@%m %k%F{black}%f " "$(buildLeftPrompt)"
}

function testContextSegmentWithForeignUser() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)

    assertEquals "%K{black} %F{yellow}%n@%m %k%F{black}%f " "$(buildLeftPrompt)"
}

# TODO: How to test root?
function testContextSegmentWithRootUser() {
    startSkipping # Skip test
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)

    assertEquals "%K{black} %F{yellow}%n@%m %k%F{black}%f " "$(buildLeftPrompt)"
}

function testOverridingContextTemplate() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)
    local P9K_CONTEXT_TEMPLATE=xx

    assertEquals "%K{black} %F{yellow}xx %k%F{black}%f " "$(buildLeftPrompt)"
}

function testContextSegmentIsShownIfDefaultUserIsSetWhenForced() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)
    local P9K_CONTEXT_ALWAYS_SHOW=true
    local DEFAULT_USER=$(whoami)

    assertEquals "%K{black} %F{yellow}%n@%m %k%F{black}%f " "$(buildLeftPrompt)"
}

function testContextSegmentIsShownIfForced() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(context)
    local P9K_CONTEXT_ALWAYS_SHOW_USER=true
    local DEFAULT_USER=$(whoami)

    assertEquals "%K{black} %F{yellow}$(whoami) %k%F{black}%f " "$(buildLeftPrompt)"
}

source shunit2/source/2.1/src/shunit2
