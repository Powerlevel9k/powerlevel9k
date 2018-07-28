#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testLeftNormalSegmentsShouldNotBeJoined() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3 custom_world4_joined custom_world5 custom_world6)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD5"
  local P9K_CUSTOM_WORLD6="echo world6"
  registerSegment "WORLD6"

  assertEquals "%K{white} %F{black}world1  %F{black}world2  %F{black}world4  %F{black}world6 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"

  assertEquals "%K{white} %F{black}world1 %F{black}world2 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftTransitiveJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo world3"
  registerSegment "WORLD3"

  assertEquals "%K{white} %F{black}world1 %F{black}world2 %F{black}world3 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftTransitiveJoiningWithConditionalJoinedSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"

  assertEquals "%K{white} %F{black}world1 %F{black}world2 %F{black}world4 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftPromotingSegmentWithConditionalPredecessor() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo world3"
  registerSegment "WORLD3"

  assertEquals "%K{white} %F{black}world1  %F{black}world3 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftPromotingSegmentWithJoinedConditionalPredecessor() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"

  assertEquals "%K{white} %F{black}world1  %F{black}world4 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined custom_world5_joined custom_world6_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD5"
  local P9K_CUSTOM_WORLD6="echo world6"
  registerSegment "WORLD6"

  assertEquals "%K{white} %F{black}world1  %F{black}world4 %F{black}world6 %k%F{white}%f " "$(buildLeftPrompt)"
}

function testLeftJoiningBuiltinSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(php_version php_version_joined)
  alias php="echo PHP 1.2.3"
  source segments/php_version.p9k

  #assertEquals "%K{013} %F{255}PHP 1.2.3 %K{013}%F{255}%F{255}PHP 1.2.3 %k%F{fuchsia}%f " "$(buildLeftPrompt)"
  assertEquals "%K{013} %F{255}PHP %f%F{255}PHP 1.2.3 %F{255}PHP %f%F{255}PHP 1.2.3 %k%F{013}%f " "$(buildLeftPrompt)"

  unalias php
}

function testRightNormalSegmentsShouldNotBeJoined() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3 custom_world4 custom_world5_joined custom_world6)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD5"
  local P9K_CUSTOM_WORLD6="echo world6"
  registerSegment "WORLD6"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world2 %F{black} %F{black}%K{white}%F{black} world4 %F{black} %F{black}%K{white}%F{black} world6 %F{black} " "$(buildRightPrompt)"
}

function testRightJoinedSegments() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %K{white}%F{black}world2 %F{black} " "$(buildRightPrompt)"
}

function testRightTransitiveJoinedSegments() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo world3"
  registerSegment "WORLD3"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %K{white}%F{black}world2 %F{black} %K{white}%F{black}world3 %F{black} " "$(buildRightPrompt)"
}

function testRightTransitiveJoiningWithConditionalJoinedSegment() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2_joined custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo world2"
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %K{white}%F{black}world2 %F{black} %K{white}%F{black}world4 %F{black} " "$(buildRightPrompt)"
}

function testRightPromotingSegmentWithConditionalPredecessor() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo world3"
  registerSegment "WORLD3"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world3 %F{black} " "$(buildRightPrompt)"
}

function testRightPromotingSegmentWithJoinedConditionalPredecessor() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world4 %F{black} " "$(buildRightPrompt)"
}

function testRightPromotingSegmentWithDeepJoinedConditionalPredecessor() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3_joined custom_world4_joined custom_world5_joined custom_world6_joined)
  local P9K_CUSTOM_WORLD1="echo world1"
  registerSegment "WORLD1"
  local P9K_CUSTOM_WORLD2="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD2"
  local P9K_CUSTOM_WORLD3="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD3"
  local P9K_CUSTOM_WORLD4="echo world4"
  registerSegment "WORLD4"
  local P9K_CUSTOM_WORLD5="echo " # Print nothing to simulate unmet conditions
  registerSegment "WORLD5"
  local P9K_CUSTOM_WORLD6="echo world6"
  registerSegment "WORLD6"

  assertEquals "%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world4 %F{black} %K{white}%F{black}world6 %F{black} " "$(buildRightPrompt)"
}

function testRightJoiningBuiltinSegmentWorks() {
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(php_version php_version_joined)
  alias php="echo PHP 1.2.3"
  source segments/php_version.p9k

  #assertEquals "%F{013}%K{013}%F{255} PHP 1.2.3 %f%K{013}%F{255}PHP 1.2.3 %F{black} " "$(buildRightPrompt)"
  assertEquals "%F{013}%K{013}%F{255} PHP 1.2.3 %F{255}PHP %K{013}%F{255}PHP 1.2.3 %F{255}PHP " "$(buildRightPrompt)"

  unalias php
}
source shunit2/source/2.1/src/shunit2
