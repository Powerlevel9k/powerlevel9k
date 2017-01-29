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
#   * $2: Alignment
#   * $3: Icon - Optional, defaults to LOAD_ICON
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
  #   * $11 signalParent: bool - Defaults to true. Set to false, if you do
  #                              not want the parent process to send SIGWINCH
  local icon='LOAD_ICON'
  [[ -n $3 ]] && icon="$3"
  serialize_segment "segment_${1}" "" "${2}" "${1}" "false" "blue" "black" "segment_${1}_content" "${icon}" "true" "false"
}

function testOverwritingIconsWork() {
  # Load icon, because we just can select one of the existing icons as
  # visual identifier. In writeCacheFile we set the visual identifier
  # to the LOAD_ICON.
  POWERLEVEL9K_LOAD_ICON='icon-here'

  writeCacheFile "1" "left"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}icon-here%f %F{black}segment_1_content %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_LOAD_ICON
}

function testVisualIdentifierAppearsBeforeSegmentContentOnLeftSegments() {
  writeCacheFile "1" "left"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}L%f %F{black}segment_1_content %k%F{blue}%f " "${PROMPT}"
}

function testVisualIdentifierAppearsAfterSegmentContentOnRightSegments() {
  writeCacheFile "1" "right"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %F{black%}L%f %f" "${RPROMPT}"
}

function testVisualIdentifierPrintsNothingIfNotAvailable() {
  writeCacheFile "1" "left" "XXX"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %k%F{blue}%f " "${PROMPT}"
}

source shunit2/source/2.1/src/shunit2
