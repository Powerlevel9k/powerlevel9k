#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testLeftNormalSegmentsShouldNotBeJoined() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3 custom_world4_joined custom_world5 custom_world6)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD6="echo world6"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}}  %F{000}\${(Q)\${:-\"world2\"}}  %F{000}\${(Q)\${:-\"world4\"}}  %F{000}\${(Q)\${:-\"world6\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}} %F{000}\${(Q)\${:-\"world2\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftTransitiveJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"
  local P9K_CUSTOM_WORLD3="echo world3"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}} %F{000}\${(Q)\${:-\"world2\"}} %F{000}\${(Q)\${:-\"world3\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftTransitiveJoiningWithConditionalJoinedSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}} %F{000}\${(Q)\${:-\"world2\"}} %F{000}\${(Q)\${:-\"world4\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftPromotingSegmentWithConditionalPredecessor() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD3="echo world3"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}}  %F{000}\${(Q)\${:-\"world3\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftPromotingSegmentWithJoinedConditionalPredecessor() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}}  %F{000}\${(Q)\${:-\"world4\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined custom_world5_joined custom_world6_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD6="echo world6"

  assertEquals "%K{015} %F{000}\${(Q)\${:-\"world1\"}}  %F{000}\${(Q)\${:-\"world4\"}} %F{000}\${(Q)\${:-\"world6\"}} %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testLeftJoiningBuiltinSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(php_version php_version_joined)
  alias php="echo PHP 1.2.3 "
  source segments/php_version/php_version.p9k

  assertEquals "%K{013} %F{255}PHP %F{255}\${(Q)\${:-\"1.2.3\"}} %F{255}PHP %F{255}\${(Q)\${:-\"1.2.3\"}} %k%F{013}%f " "$(__p9k_build_left_prompt)"

  unalias php
}

function testRightNormalSegmentsShouldNotBeJoined() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3 custom_world4 custom_world5_joined custom_world6)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD6="echo world6"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %F{000}%K{015}%F{000} \${(Q)\${:-\"world2\"}} %F{000}%K{015}%F{000} \${(Q)\${:-\"world4\"}} %F{000}%K{015}%F{000} \${(Q)\${:-\"world6\"}} " "$(__p9k_build_right_prompt)"
}

function testRightJoinedSegments() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %K{015}%F{000}\${(Q)\${:-\"world2\"}} " "$(__p9k_build_right_prompt)"
}

function testRightTransitiveJoinedSegments() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"
  local P9K_CUSTOM_WORLD3="echo world3"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %K{015}%F{000}\${(Q)\${:-\"world2\"}} %K{015}%F{000}\${(Q)\${:-\"world3\"}} " "$(__p9k_build_right_prompt)"
}

function testRightTransitiveJoiningWithConditionalJoinedSegment() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo world2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %K{015}%F{000}\${(Q)\${:-\"world2\"}} %K{015}%F{000}\${(Q)\${:-\"world4\"}} " "$(__p9k_build_right_prompt)"
}

function testRightPromotingSegmentWithConditionalPredecessor() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD3="echo world3"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %F{000}%K{015}%F{000} \${(Q)\${:-\"world3\"}} " "$(__p9k_build_right_prompt)"
}

function testRightPromotingSegmentWithJoinedConditionalPredecessor() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %F{000}%K{015}%F{000} \${(Q)\${:-\"world4\"}} " "$(__p9k_build_right_prompt)"
}

function testRightPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined custom_world5_joined custom_world6_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD4="echo world4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  local P9K_CUSTOM_WORLD6="echo world6"

  assertEquals "%F{015}%K{015}%F{000} \${(Q)\${:-\"world1\"}} %F{000}%K{015}%F{000} \${(Q)\${:-\"world4\"}} %K{015}%F{000}\${(Q)\${:-\"world6\"}} " "$(__p9k_build_right_prompt)"
}

function testRightJoiningBuiltinSegmentWorks() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(php_version php_version_joined)
  alias php="echo PHP 1.2.3"
  source segments/php_version/php_version.p9k

  assertEquals "%F{013}%K{013}%F{255} \${(Q)\${:-\"1.2.3\"}} %F{255}PHP%f %K{013}%F{255}\${(Q)\${:-\"1.2.3\"}} %F{255}PHP%f " "$(__p9k_build_right_prompt)"

  unalias php
}
source shunit2/shunit2
