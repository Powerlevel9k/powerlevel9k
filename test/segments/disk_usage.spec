#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

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
  rm -f ${POWERLEVEL9K_PUBLIC_IP_FILE}

  p9k_clear_cache
}

function testDiskUsageSegmentWhenDiskIsAlmostFull() {
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  97% /"
  }

  prompt_disk_usage "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{red} %F{white%}hdd %f %F{white}97%% %k%F{red}%f " "${PROMPT}"

  unfunction df
}

function testDiskUsageSegmentWhenDiskIsVeryFull() {
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  94% /"
  }

  prompt_disk_usage "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black%}hdd %f %F{black}94%% %k%F{yellow}%f " "${PROMPT}"

  unfunction df
}

function testDiskUsageSegmentWhenDiskIsQuiteEmpty() {
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  4% /"
  }

  prompt_disk_usage "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{yellow%}hdd %f %F{yellow}4%% %k%F{black}%f " "${PROMPT}"

  unfunction df
}

function testDiskUsageSegmentPrintsNothingIfDiskIsQuiteEmptyAndOnlyWarningsShouldBeDisplayed() {
  POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=true
  df() {
      echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  4% /"
  }

  POWERLEVEL9K_CUSTOM_WORLD='echo world'
  prompt_custom "left" "2" "world" "false"
  prompt_disk_usage "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
  unfunction df
  unset POWERLEVEL9K_DISK_USAGE_ONLY_WARNING
}

function testDiskUsageSegmentWarningLevelCouldBeAdjusted() {
  POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=10
  df() {
    echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  11% /"
  }

  prompt_disk_usage "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black%}hdd %f %F{black}11%% %k%F{yellow}%f " "${PROMPT}"

  unfunction df
  unset POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL
}

function testDiskUsageSegmentCriticalLevelCouldBeAdjusted() {
  POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=5
  POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=10
  df() {
    echo "Filesystem     1K-blocks      Used Available Use% Mounted on
/dev/disk1     487219288 471466944  15496344  11% /"
  }

  prompt_disk_usage "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{red} %F{white%}hdd %f %F{white}11%% %k%F{red}%f " "${PROMPT}"

  unfunction df
  unset POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL
  unset POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL
}

source shunit2/source/2.1/src/shunit2