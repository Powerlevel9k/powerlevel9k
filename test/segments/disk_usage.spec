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

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{red} %F{white}hdd  %f%F{white}97%% %k%F{red}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentWhenDiskIsVeryFull() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  94% /"
  }

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{yellow} %F{black}hdd  %f%F{black}94%% %k%F{yellow}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

function testDiskUsageSegmentWhenDiskIsQuiteEmpty() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(disk_usage)
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  4% /"
  }

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{black} %F{green1}hdd  %f%F{green1}4%% %k%F{black}%f " "$(__p9k_build_left_prompt)"

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
  p9k::register_segment "WORLD"
  p9k::register_segment "WORLD"

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "$(__p9k_build_left_prompt)"

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

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{yellow} %F{black}hdd  %f%F{black}11%% %k%F{yellow}%f " "$(__p9k_build_left_prompt)"

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

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{red} %F{white}hdd  %f%F{white}11%% %k%F{red}%f " "$(__p9k_build_left_prompt)"

  unfunction df
}

source shunit2/source/2.1/src/shunit2
