#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function oneTimeSetUp() {
  source ./test/performance/libperf.zsh
}

function setUp() {
  export TERM="xterm-256color"
}

function testIpSegmentPerformance() {
  local -a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ip)

  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  samplePerformanceSilent "IP Segment" build_left_prompt
}

source shunit2/shunit2
