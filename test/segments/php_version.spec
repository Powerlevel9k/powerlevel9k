#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/php_version.p9k
}

function testPhpVersionSegmentPrintsNothingIfPhpIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(php_version custom_world)
  local P9K_CUSTOM_WORLD='echo world'
  alias php="nophp"

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias php
}

function testPhpVersionSegmentWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(php_version)
  alias php="echo 'PHP 5.6.27 (cli) (built: Oct 23 2016 11:47:58)
Copyright (c) 1997-2016 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies
'"

  assertEquals "%K{013} %F{255}PHP %f%F{255}5.6.27 %k%F{013}%f " "$(__p9k_build_left_prompt)"

  unalias php
}

source shunit2/shunit2
