#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source functions/*

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
#   * $2: State - Optional
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
  serialize_segment "segment_${1}" "${2}" "left" "${1}" "false" "blue" "black" "segment_${1}_content" "LOAD_ICON" "true"
}

function testDynamicColoringOfSegmentsWork() {
  POWERLEVEL9K_SEGMENT_1_BACKGROUND='red'
  writeCacheFile "1"
  p9k_build_prompt_from_cache

  assertEquals "%K{red} %F{black%}L%f %F{black}segment_1_content %k%F{red}%f " "${PROMPT}"

  unset POWERLEVEL9K_SEGMENT_1_BACKGROUND
}

function testDynamicColoringOfVisualIdentifiersWork() {
  POWERLEVEL9K_SEGMENT_1_VISUAL_IDENTIFIER_COLOR='green'
  writeCacheFile "1"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{green%}L%f %F{black}segment_1_content %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_MODE
  unset POWERLEVEL9K_SEGMENT_1_VISUAL_IDENTIFIER_COLOR
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  POWERLEVEL9K_SEGMENT_1_VISUAL_IDENTIFIER_COLOR='green'
  POWERLEVEL9K_SEGMENT_1_FOREGROUND='red'
  POWERLEVEL9K_SEGMENT_1_BACKGROUND='yellow'
  writeCacheFile "1"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{green%}L%f %F{red}segment_1_content %k%F{yellow}%f " "${PROMPT}"

  unset POWERLEVEL9K_SEGMENT_1_VISUAL_IDENTIFIER_COLOR
  unset POWERLEVEL9K_SEGMENT_1_FOREGROUND
  unset POWERLEVEL9K_SEGMENT_1_BACKGROUND
}

function testColorOverridingOfStatefulSegment() {
  POWERLEVEL9K_SEGMENT_1_STATE_BACKGROUND='red'
  POWERLEVEL9K_SEGMENT_1_STATE_FOREGROUND='green'

  writeCacheFile "1" "state"
  p9k_build_prompt_from_cache

  assertEquals "%K{red} %F{green%}L%f %F{green}segment_1_content %k%F{red}%f " "${PROMPT}"

  unset POWERLEVEL9K_SEGMENT_1_BACKGROUND
  unset POWERLEVEL9K_SEGMENT_1_FOREGROUND
}

function testColorOverridingOfCustomSegment() {
  POWERLEVEL9K_CUSTOM_WORLD='echo world'
  POWERLEVEL9K_CUSTOM_WORLD_BACKGROUND='red'
  POWERLEVEL9K_CUSTOM_WORLD_FOREGROUND='green'

  prompt_custom "left" "1" "world" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{red} %F{green}world %k%F{red}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
  unset POWERLEVEL9K_CUSTOM_WORLD_BACKGROUND
  unset POWERLEVEL9K_CUSTOM_WORLD_FOREGROUND
}

source shunit2/source/2.1/src/shunit2
