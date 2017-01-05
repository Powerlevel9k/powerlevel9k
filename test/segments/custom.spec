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

function testCustomDirectOutputSegment() {
    POWERLEVEL9K_CUSTOM_WORLD="echo world"

    prompt_custom "left" "1" "world" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
}

function testCustomClosureSegment() {
    function p9k_hello_world() {
        echo "world"
    }
    POWERLEVEL9K_CUSTOM_WORLD='p9k_hello_world'

    prompt_custom "left" "1" "world" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
}

function testSettingBackgroundForCustomSegment() {
    POWERLEVEL9K_CUSTOM_WORLD="echo world"
    POWERLEVEL9K_CUSTOM_WORLD_BACKGROUND="yellow"

    prompt_custom "left" "1" "world" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{yellow} %F{black}world %k%F{yellow}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unset POWERLEVEL9K_CUSTOM_WORLD_BACKGROUND
}

function testSettingForegroundForCustomSegment() {
    POWERLEVEL9K_CUSTOM_WORLD="echo world"
    POWERLEVEL9K_CUSTOM_WORLD_FOREGROUND="red"

    prompt_custom "left" "1" "world" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{red}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unset POWERLEVEL9K_CUSTOM_WORLD_FOREGROUND
}

function testSettingVisualIdentifierForCustomSegment() {
    POWERLEVEL9K_CUSTOM_WORLD="echo world"
    POWERLEVEL9K_CUSTOM_WORLD_ICON="hw"

    prompt_custom "left" "1" "world" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{black%}hw%f %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unset POWERLEVEL9K_CUSTOM_WORLD_ICON
}

function testSettingVisualIdentifierForegroundColorForCustomSegment() {
    POWERLEVEL9K_CUSTOM_WORLD="echo world"
    POWERLEVEL9K_CUSTOM_WORLD_ICON="hw"
    POWERLEVEL9K_CUSTOM_WORLD_VISUAL_IDENTIFIER_COLOR="red"

    prompt_custom "left" "1" "world" "false"
    p9k_build_prompt_from_cache

    assertEquals "%K{white} %F{red%}hw%f %F{black}world %k%F{white}%f " "${PROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD
    unset POWERLEVEL9K_CUSTOM_WORLD_ICON
    unset POWERLEVEL9K_CUSTOM_WORLD_VISUAL_IDENTIFIER_COLOR
}

source shunit2/source/2.1/src/shunit2
