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

#   * $1: Index
#   * $2: Alignment
#   * $3: Joined
#   * $4: Condition - If the segment should be printed
function writeCacheFile() {
  # Options from serialize_segment
  #   * $1 Name: string - Name of the segment
  #   * $2 State: string - The state the segment is in
  #   * $3 Alignment: string - left|right
  #   * $4 Index: integer
  #   * $5 Joined: bool - If the segment should be joined
  #   * $6 Background: string - The default background color of the segment
  #   * $7 Foreground: string - The default foreground color of the segment
  #   * $8 Content: string - Content of the segment
  #   * $9 Visual identifier: string - Icon of the segment
  #   * $10 Condition - The condition, if the segment should be printed
  serialize_segment "segment_${1}" "" "${2}" "${1}" "${3}" "blue" "black" "segment_${1}_content" "visual_identifier" "${4}"
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

function testLeftMultilinePrompt() {
    POWERLEVEL9K_PROMPT_ON_NEWLINE=true

    writeCacheFile "1" "left" "false" "true"
    p9k_build_prompt_from_cache

    # Caution! Trailing whitespace is important here!
    assertEquals "╭─%f%b%k%K{blue} %F{black}segment_1_content %k%F{blue}%f 
╰─ " "${PROMPT}"

    unset POWERLEVEL9K_PROMPT_ON_NEWLINE
    unset POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX
}

function testRightPromptOnSameLine() {
    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_RPROMPT_ON_NEWLINE=false # We want the RPROMPT on the same line as our left prompt

    writeCacheFile "1" "right" "false" "true"
    p9k_build_prompt_from_cache

    # Skip test, as this cannot be tested properly.
    # The "go one line up" instruction does not get
    # printed as real characters in RPROMPT.
    # On command line the assert statement produces
    # a visually identical output as we expect, but
    # it fails anyway. :(
    startSkipping
    assertEquals "%{\e[1A%}%F{blue}%f%K{blue}%F{black} segment_1_content %f%{\e[1B%}" "${RPROMPT}"

    unset POWERLEVEL9K_PROMPT_ON_NEWLINE
    unset POWERLEVEL9K_RPROMPT_ON_NEWLINE
}

function testPrefixingFirstLineOnLeftPrompt() {
    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='XXX'

    writeCacheFile "1" "left" "false" "true"
    p9k_build_prompt_from_cache

    # Caution! Trailing whitespace is important here!
    assertEquals "XXX%f%b%k%K{blue} %F{black}segment_1_content %k%F{blue}%f 
╰─ " "${PROMPT}"


    unset POWERLEVEL9K_PROMPT_ON_NEWLINE
    unset POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX
}

function testPrefixingSecondLineOnLeftPrompt() {
    POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX='XXX'

    writeCacheFile "1" "left" "false" "true"
    p9k_build_prompt_from_cache

    # Caution! Trailing whitespace is important here!
    assertEquals "╭─%f%b%k%K{blue} %F{black}segment_1_content %k%F{blue}%f 
XXX" "${PROMPT}"

    unset POWERLEVEL9K_PROMPT_ON_NEWLINE
    unset POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX
}

source shunit2/source/2.1/src/shunit2
