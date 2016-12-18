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

function testSegmentOnRightSide() {
    POWERLEVEL9K_CUSTOM_WORLD1='echo world1'
    POWERLEVEL9K_CUSTOM_WORLD2='echo world2'
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)

    powerlevel9k_prepare_prompts
    # Stupid hack: We need to give the segments writing their cache
    # files a bit time, so we sleep here for a second...
    sleep 1
    p9k_build_prompt_from_cache

    assertEquals "%F{white}%f%K{white}%F{black} world1 %f%F{black}%f%K{white}%F{black} world2 %f" "${RPROMPT}"

    unset POWERLEVEL9K_CUSTOM_WORLD1
    unset POWERLEVEL9K_CUSTOM_WORLD2
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

function testDisablingRightPrompt() {
    POWERLEVEL9K_CUSTOM_WORLD1='echo world1'
    POWERLEVEL9K_CUSTOM_WORLD2='echo world2'
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
    POWERLEVEL9K_DISABLE_RPROMPT=true

    powerlevel9k_prepare_prompts
    # Stupid hack: We need to give the segments writing their cache
    # files a bit time, so we sleep here for a second... This is
    # especially stupid as we want to test if the segments didn'to
    # get printed when we set `POWERLEVEL9K_DISABLE_RPROMPT` to true.
    sleep 1
    p9k_build_prompt_from_cache

    assertEquals "" "${RPROMPT}"

    unset POWERLEVEL9K_DISABLE_RPROMPT
    unset POWERLEVEL9K_CUSTOM_WORLD1
    unset POWERLEVEL9K_CUSTOM_WORLD2
    unset POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS
}

source shunit2/source/2.1/src/shunit2
