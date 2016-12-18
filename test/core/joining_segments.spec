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

function testLeftNormalSegmentsShouldNotBeJoined() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "false" "true"
  writeCacheFile "3" "left" "false" "false"
  writeCacheFile "4" "left" "false" "true"
  writeCacheFile "5" "left" "true" "false"
  writeCacheFile "6" "left" "false" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_2_content %K{blue}%F{black} %F{black}segment_4_content %K{blue}%F{black} %F{black}segment_6_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftJoinedSegments() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black}%F{black}segment_2_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftTransitiveJoinedSegments() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "true" "true"
  writeCacheFile "3" "left" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black}%F{black}segment_2_content %K{blue}%F{black}%F{black}segment_3_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftTransitiveJoiningWithConditionalJoinedSegment() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "true" "true"
  writeCacheFile "3" "left" "true" "false"
  writeCacheFile "4" "left" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black}%F{black}segment_2_content %K{blue}%F{black}%F{black}segment_4_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftPromotingSegmentWithConditionalPredecessor() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "false" "false"
  writeCacheFile "3" "left" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_3_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftPromotingSegmentWithJoinedConditionalPredecessor() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "false" "false"
  writeCacheFile "3" "left" "true" "false"
  writeCacheFile "4" "left" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_4_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "false" "false"
  writeCacheFile "3" "left" "true" "false"
  writeCacheFile "4" "left" "true" "true"
  writeCacheFile "5" "left" "true" "false"
  writeCacheFile "6" "left" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{blue}%F{black} %F{black}segment_4_content %K{blue}%F{black}%F{black}segment_6_content %k%F{blue}%f " "${PROMPT}"
}

function testLeftJoiningCustomSegmentWorks() {
  POWERLEVEL9K_CUSTOM_WORLD='echo world'

  writeCacheFile "1" "left" "false" "true"
  writeCacheFile "2" "left" "true" "false"
  writeCacheFile "3" "left" "true" "false"
  prompt_custom "left" "4" "world" "true"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}segment_1_content %K{white}%F{blue}%F{black}world %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
}

function testRightNormalSegmentsShouldNotBeJoined() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "false" "true"
  writeCacheFile "3" "right" "false" "false"
  writeCacheFile "4" "right" "false" "true"
  writeCacheFile "5" "right" "true" "false"
  writeCacheFile "6" "right" "false" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%F{black}%f%K{blue}%F{black} segment_2_content %f%F{black}%f%K{blue}%F{black} segment_4_content %f%F{black}%f%K{blue}%F{black} segment_6_content %f" "${RPROMPT}"
}

function testRightJoinedSegments() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%K{blue}%F{black}segment_2_content %f" "${RPROMPT}"
}

function testRightTransitiveJoinedSegments() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "true" "true"
  writeCacheFile "3" "right" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%K{blue}%F{black}segment_2_content %f%K{blue}%F{black}segment_3_content %f" "${RPROMPT}"
}

function testRightTransitiveJoiningWithConditionalJoinedSegment() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "true" "true"
  writeCacheFile "3" "right" "true" "false"
  writeCacheFile "4" "right" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%K{blue}%F{black}segment_2_content %f%K{blue}%F{black}segment_4_content %f" "${RPROMPT}"
}

function testRightPromotingSegmentWithConditionalPredecessor() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "false" "false"
  writeCacheFile "3" "right" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%F{black}%f%K{blue}%F{black} segment_3_content %f" "${RPROMPT}"
}

function testRightPromotingSegmentWithJoinedConditionalPredecessor() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "false" "false"
  writeCacheFile "3" "right" "true" "false"
  writeCacheFile "4" "right" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%F{black}%f%K{blue}%F{black} segment_4_content %f" "${RPROMPT}"
}

function testRightPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "false" "false"
  writeCacheFile "3" "right" "true" "false"
  writeCacheFile "4" "right" "true" "true"
  writeCacheFile "5" "right" "true" "false"
  writeCacheFile "6" "right" "true" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%F{black}%f%K{blue}%F{black} segment_4_content %f%K{blue}%F{black}segment_6_content %f" "${RPROMPT}"
}

function testRightJoiningCustomSegmentWorks() {
  POWERLEVEL9K_CUSTOM_WORLD='echo world'

  writeCacheFile "1" "right" "false" "true"
  writeCacheFile "2" "right" "true" "false"
  writeCacheFile "3" "right" "true" "false"
  prompt_custom "right" "4" "world" "true"
  p9k_build_prompt_from_cache

  assertEquals "%F{blue}%f%K{blue}%F{black} segment_1_content %f%K{white}%F{black}world %f" "${RPROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
}
source shunit2/source/2.1/src/shunit2