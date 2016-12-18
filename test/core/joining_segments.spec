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
#   * $2: Joined
#   * $3: Condition - If the segment should be printed
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
  serialize_segment "segment_${1}" "" "left" "${1}" "${2}" "blue" "black" "segment_${1}_content" "visual_identifier" "${3}"
}

function testNormalSegmentsShouldNotBeJoined() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "false" "true"
  writeCacheFile "3" "false" "false"
  writeCacheFile "4" "false" "true"
  writeCacheFile "5" "true" "false"
  writeCacheFile "6" "false" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_2_content %K{blue}%F{black} %F{black}segment_4_content %K{blue}%F{black} %F{black}segment_6_content %k%F{blue}%f " "${PROMPT}"
}

function testJoinedSegments() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black}%F{black}segment_2_content %k%F{blue}%f " "${PROMPT}"
}

function testTransitiveJoinedSegments() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "true" "true"
  writeCacheFile "3" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black}%F{black}segment_2_content %K{blue}%F{black}%F{black}segment_3_content %k%F{blue}%f " "${PROMPT}"
}

function testTransitiveJoiningWithConditionalJoinedSegment() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "true" "true"
  writeCacheFile "3" "true" "false"
  writeCacheFile "4" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black}%F{black}segment_2_content %K{blue}%F{black}%F{black}segment_4_content %k%F{blue}%f " "${PROMPT}"
}

function testPromotingSegmentWithConditionalPredecessor() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "false" "false"
  writeCacheFile "3" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_3_content %k%F{blue}%f " "${PROMPT}"
}

function testPromotingSegmentWithJoinedConditionalPredecessor() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "false" "false"
  writeCacheFile "3" "true" "false"
  writeCacheFile "4" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_4_content %k%F{blue}%f " "${PROMPT}"
}

function testPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  writeCacheFile "1" "false" "true"
  writeCacheFile "2" "false" "false"
  writeCacheFile "3" "true" "false"
  writeCacheFile "4" "true" "true"
  writeCacheFile "5" "true" "false"
  writeCacheFile "6" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_4_content %K{blue}%F{black}%F{black}segment_6_content %k%F{blue}%f " "${PROMPT}"
}

source shunit2/source/2.1/src/shunit2