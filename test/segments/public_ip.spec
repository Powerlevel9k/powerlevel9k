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

  # Change cache file, so that the users environment don't
  # interfere with the tests.
  POWERLEVEL9K_PUBLIC_IP_FILE=$FOLDER/public_ip_file
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

  # Unset cache file
  unset POWERLEVEL9K_PUBLIC_IP_FILE

  p9k_clear_cache
}

function testPublicIpSegmentPrintsNothingByDefaultIfHostIsNotAvailable() {
  # We need to overwrite dig, as this is a fallback method that
  # uses an alternative host.
  alias dig='nodig'
  POWERLEVEL9K_PUBLIC_IP_HOST='http://unknown.xyz'
  POWERLEVEL9K_CUSTOM_WORLD='echo world'

  prompt_custom "left" "2" "world" "false"
  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{white} %F{black}world %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_CUSTOM_WORLD
  unset POWERLEVEL9K_PUBLIC_IP_HOST
  unalias dig
}

function testPublicIpSegmentPrintsNoticeIfNotConnected() {
  # We need to overwrite dig, as this is a fallback method that
  # uses an alternative host.
  alias dig='nodig'
  POWERLEVEL9K_PUBLIC_IP_HOST='http://unknown.xyz'
  POWERLEVEL9K_PUBLIC_IP_NONE="disconnected"

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}disconnected %k%F{black}%f " "${PROMPT}"

  unset POWERLEVEL9K_PUBLIC_IP_NONE
  unset POWERLEVEL9K_PUBLIC_IP_HOST
  unalias dig
}

function testPublicIpSegmentWorksWithWget() {
  alias dig='nodig'
  alias curl='nocurl'
  wget() {
      echo "wget 1.2.3.4"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}wget 1.2.3.4 %k%F{black}%f " "${PROMPT}"

  unfunction wget
  unalias dig
  unalias curl
}

function testPublicIpSegmentUsesCurlAsFallbackMethodIfWgetIsNotAvailable() {
  alias dig='nodig'
  alias wget='nowget'
  curl() {
      echo "curl 1.2.3.4"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}curl 1.2.3.4 %k%F{black}%f " "${PROMPT}"

  unfunction curl
  unalias dig
  unalias wget
}

function testPublicIpSegmentUsesDigAsFallbackMethodIfWgetAndCurlAreNotAvailable() {
  alias curl='nocurl'
  alias wget='nowget'
  dig() {
      echo "dig 1.2.3.4"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}dig 1.2.3.4 %k%F{black}%f " "${PROMPT}"

  unfunction dig
  unalias curl
  unalias wget
}

function testPublicIpSegmentCachesFile() {
  dig() {
      echo "first"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}first %k%F{black}%f " "${PROMPT}"

  dig() {
      echo "second"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  # Segment should not have changed!
  assertEquals "%K{black} %F{white}first %k%F{black}%f " "${PROMPT}"

  unfunction dig
}

function testPublicIpSegmentRefreshesCachesFileAfterTimeout() {
  POWERLEVEL9K_PUBLIC_IP_TIMEOUT=2
  dig() {
      echo "first"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}first %k%F{black}%f " "${PROMPT}"

  sleep 3
  dig() {
      echo "second"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  # Segment should not have changed!
  assertEquals "%K{black} %F{white}second %k%F{black}%f " "${PROMPT}"

  unfunction dig
  unset POWERLEVEL9K_PUBLIC_IP_TIMEOUT
}

function testPublicIpSegmentRefreshesCachesFileIfEmpty() {
  dig() {
      echo "first"
  }

  # First run, so that cache file exists
  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}first %k%F{black}%f " "${PROMPT}"

  # Truncate cache file
  echo "" >! $POWERLEVEL9K_PUBLIC_IP_FILE

  dig() {
      echo "second"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  # Segment should not have changed!
  assertEquals "%K{black} %F{white}second %k%F{black}%f " "${PROMPT}"

  unfunction dig
}

function testPublicIpSegmentWhenGoingOnline() {
  alias dig="nodig"
  POWERLEVEL9K_PUBLIC_IP_METHODS="dig"
  POWERLEVEL9K_PUBLIC_IP_NONE="disconnected"

  # First run, so that cache file exists
  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{black} %F{white}disconnected %k%F{black}%f " "${PROMPT}"

  unalias dig

  dig() {
      echo "second"
  }

  prompt_public_ip "left" "1" "false"
  p9k_build_prompt_from_cache

  # Segment should not have changed!
  assertEquals "%K{black} %F{white}second %k%F{black}%f " "${PROMPT}"

  unfunction dig
  unset POWERLEVEL9K_PUBLIC_IP_NONE
  unset POWERLEVEL9K_PUBLIC_IP_METHODS
}

source shunit2/source/2.1/src/shunit2