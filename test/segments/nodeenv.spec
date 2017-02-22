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

  # Test specfic
  # unset all possible user specified variables
  unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
  unset NODE_VIRTUAL_ENV
}

function tearDown() {
    p9k_clear_cache
}

function testNodeenvSegmentPrintsNothingWithoutNode() {
    POWERLEVEL9K_CUSTOM_WORLD='echo world'
    alias node="nonode 2>/dev/null"

    prompt_custom "left" "2" "world" "false"
    prompt_nodeenv "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unalias node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvIsNotSet() {
    POWERLEVEL9K_CUSTOM_WORLD='echo world'
    node() {
        echo "v1.2.3"
    }

    prompt_custom "left" "2" "world" "false"
    prompt_nodeenv "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unfunction node
}

function testNodeenvSegmentPrintsNothingIfNodeVirtualEnvDisablePromptIsSet() {
    POWERLEVEL9K_CUSTOM_WORLD='echo world'
    node() {
        echo "v1.2.3"
    }
    NODE_VIRTUAL_ENV="node-env"
    NODE_VIRTUAL_ENV_DISABLE_PROMPT=true

    prompt_custom "left" "2" "world" "false"
    prompt_nodeenv "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unset NODE_VIRTUAL_ENV_DISABLE_PROMPT
    unset NODE_VIRTUAL_ENV
    unfunction node
}

function testNodeenvSegmentPrintsAtLeastNodeEnvWithoutNode() {
    alias node="nonode 2>/dev/null"
    NODE_VIRTUAL_ENV="node-env"

    prompt_nodeenv "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{green%}⬢%f %F{green}[node-env] %k%F{black}%f " "${PROMPT}"

    unset NODE_VIRTUAL_ENV
    unalias node
}

function testNodeenvSegmentWorks() {
    node() {
        echo "v1.2.3"
    }
    NODE_VIRTUAL_ENV="node-env"

    prompt_nodeenv "left" "1" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{black} %F{green%}⬢%f %F{green}v1.2.3[node-env] %k%F{black}%f " "${PROMPT}"

    unfunction node
    unset NODE_VIRTUAL_ENV
}

source shunit2/source/2.1/src/shunit2