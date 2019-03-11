#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  # Test specific
  P9K_HOME=$(pwd)
  FOLDER=/tmp/powerlevel9k-test
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  source "${P9K_HOME}/powerlevel9k.zsh-theme"
  source "${P9K_HOME}/segments/disk_usage/disk_usage.p9k"
  mkdir -p $FOLDER
  cd $FOLDER
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
  unset FOLDER
  unset P9K_HOME

  # Remove IP cache file
  rm -f ${P9K_PUBLIC_IP_FILE}
}

function testDiskUsageSegmentWhenDiskIsAlmostFull() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  97% /"
  }

  assertEquals "%K{001} %F{015}hdd  %F{015}97%% %k%F{001}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentWhenDiskIsVeryFull() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  94% /"
  }

  assertEquals "%K{003} %F{000}hdd  %F{000}94%% %k%F{003}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentWhenDiskIsQuiteEmpty() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  4% /"
  }

  assertEquals "%K{000} %F{046}hdd  %F{046}4%% %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentPrintsNothingIfDiskIsQuiteEmptyAndOnlyWarningsShouldBeDisplayed() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage custom_world)
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  4% /"
  }

  local P9K_DISK_USAGE_ONLY_WARNING=true
  local P9K_CUSTOM_WORLD='echo world'

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentWarningLevelCouldBeAdjusted() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  local P9K_DISK_USAGE_WARNING_LEVEL=10
  df() {
    echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  11% /"
  }

  assertEquals "%K{003} %F{000}hdd  %F{000}11%% %k%F{003}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentCriticalLevelCouldBeAdjusted() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  local P9K_DISK_USAGE_WARNING_LEVEL=5
  local P9K_DISK_USAGE_CRITICAL_LEVEL=10
  df() {
    echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  11% /"
  }

  assertEquals "%K{001} %F{015}hdd  %F{015}11%% %k%F{001}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

source shunit2/shunit2
