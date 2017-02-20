#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  # Disable TRAP, so that we have more control how the segment is build,
  # as shUnit does not work with async commands.
  trap WINCH

  # Test specific settings
  OLD_DEFAULT_USER=$DEFAULT_USER
  unset DEFAULT_USER
}

function tearDown() {
  p9k_clear_cache

  # Restore old variables
  [[ -n "$OLD_DEFAULT_USER" ]] && DEFAULT_USER=$OLD_DEFAULT_USER
}

function testContextSegmentDoesNotGetRenderedWithDefaultUser() {
    export DEFAULT_USER=$(whoami)
    POWERLEVEL9K_CUSTOM_WORLD='echo world'

    prompt_custom "left" "2" "world" "false"
    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset DEFAULT_USER
    unset POWERLEVEL9K_CUSTOM_WORLD
}

function testContextSegmentDoesGetRenderedWhenSshConnectionIsOpen() {
    export SSH_CLIENT="putty"

    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache 0

    assertEquals "%K{black} %F{011}%n@%m %k%F{black}%f " "${PROMPT}"

    unset SSH_CLIENT
}

function testContextSegmentWithForeignUser() {
    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache 0

    assertEquals "%K{black} %F{011}%n@%m %k%F{black}%f " "${PROMPT}"
}

# TODO: How to test root?
function testContextSegmentWithRootUser() {
    startSkipping # Skip test
    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache 0

    assertEquals "%K{black} %F{011}%n@%m %k%F{black}%f " "${PROMPT}"
}

function testOverridingContextTemplate() {
    POWERLEVEL9K_CONTEXT_TEMPLATE=xx

    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache 0

    assertEquals "%K{black} %F{011}xx %k%F{black}%f " "${PROMPT}"

    unset POWERLEVEL9K_CONTEXT_TEMPLATE
}

function testContextSegmentIsShownIfDefaultUserIsSetWhenForced() {
    POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true
    export DEFAULT_USER=$(whoami)

    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache 0

    assertEquals "%K{black} %F{011}%n@%m %k%F{black}%f " "${PROMPT}"

    unset DEFAULT_USER
    unset POWERLEVEL9K_ALWAYS_SHOW_CONTEXT
}

function testContextSegmentIsShownIfForced() {
    POWERLEVEL9K_ALWAYS_SHOW_USER=true
    DEFAULT_USER=$(whoami)

    prompt_context "left" "1" "false"
    p9k_build_prompt_from_cache 0

    assertEquals "%K{black} %F{011}$(whoami) %k%F{black}%f " "${PROMPT}"

    unset POWERLEVEL9K_ALWAYS_SHOW_USER
    unset DEFAULT_USER
}

source shunit2/source/2.1/src/shunit2
