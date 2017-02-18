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
}

function tearDown() {
    p9k_clear_cache
}

function testNodeVersionSegmentPrintsNothingWithoutNode() {
    POWERLEVEL9K_CUSTOM_WORLD='echo world'
    alias node="nonode 2>/dev/null"

    prompt_custom "left" "2" "world" "false"
    prompt_node_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unalias node
}

function testNodeVersionSegmentWorks() {
    node() {
        echo "v1.2.3"
    }

    prompt_node_version "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{green} %F{white%}⬢%f %F{white}1.2.3 %k%F{green}%f " "${PROMPT}"

    unfunction node
}

source shunit2/source/2.1/src/shunit2