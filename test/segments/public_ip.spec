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

  # Change cache file, so that the users environment don't
  # interfere with the tests.
  P9K_PUBLIC_IP_FILE=$FOLDER/public_ip_file

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme
  source ${P9K_HOME}/segments/public_ip.p9k
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
  unset P9K_PUBLIC_IP_FILE
}

function testPublicIpSegmentPrintsNothingByDefaultIfHostIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip custom_world)
  local P9K_PUBLIC_IP_HOST='http://unknown.xyz'
  local P9K_CUSTOM_WORLD='echo world'
  p9k::register_segment "WORLD"
  # We need to overwrite dig, as this is a fallback method that
  # uses an alternative host.
  alias dig='nodig'

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias dig
}

function testPublicIpSegmentPrintsNoticeIfNotConnected() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  local P9K_PUBLIC_IP_HOST='http://unknown.xyz'
  local P9K_PUBLIC_IP_NONE="disconnected"
  # We need to overwrite dig, as this is a fallback method that
  # uses an alternative host.
  alias dig='nodig'

  assertEquals "%K{000} %F{015}disconnected %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unalias dig
}

function testPublicIpSegmentWorksWithWget() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  alias dig='nodig'
  alias curl='nocurl'
  wget() {
    echo "wget 1.2.3.4"
  }

  assertEquals "%K{000} %F{015}wget 1.2.3.4 %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction wget
  unalias dig
  unalias curl
}

function testPublicIpSegmentUsesCurlAsFallbackMethodIfWgetIsNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  alias dig='nodig'
  alias wget='nowget'
  curl() {
    echo "curl 1.2.3.4"
  }

  assertEquals "%K{000} %F{015}curl 1.2.3.4 %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction curl
  unalias dig
  unalias wget
}

function testPublicIpSegmentUsesDigAsFallbackMethodIfWgetAndCurlAreNotAvailable() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  alias curl='nocurl'
  alias wget='nowget'
  dig() {
    echo "dig 1.2.3.4"
  }

  # Load Powerlevel9k
  assertEquals "%K{000} %F{015}dig 1.2.3.4 %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction dig
  unalias curl
  unalias wget
}

function testPublicIpSegmentCachesFile() {
  local P9K_PUBLIC_IP_TIMEOUT=60
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  dig() {
    echo "first"
  }

  assertEquals "%K{000} %F{015}first %k%F{000}%f " "$(__p9k_build_left_prompt)"

  dig() {
    echo "second"
  }

  # Segment should not have changed!
  assertEquals "%K{000} %F{015}first %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction dig
}

function testPublicIpSegmentRefreshesCachesFileAfterTimeout() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  local P9K_PUBLIC_IP_TIMEOUT=2
  dig() {
    echo "first"
  }

  assertEquals "%K{000} %F{015}first %k%F{000}%f " "$(__p9k_build_left_prompt)"

  sleep 3
  dig() {
    echo "second"
  }

  # Segment should not have changed!
  assertEquals "%K{000} %F{015}second %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction dig
}

function testPublicIpSegmentRefreshesCachesFileIfEmpty() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  dig() {
    echo "first"
  }

  assertEquals "%K{000} %F{015}first %k%F{000}%f " "$(__p9k_build_left_prompt)"

  # Truncate cache file
  echo "" >! $P9K_PUBLIC_IP_FILE

  dig() {
    echo "second"
  }

  # Segment should not have changed!
  assertEquals "%K{000} %F{015}second %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction dig
}

function testPublicIpSegmentWhenGoingOnline() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(public_ip)
  local P9K_PUBLIC_IP_METHODS="dig"
  local P9K_PUBLIC_IP_NONE="disconnected"
  alias dig="nodig"

  assertEquals "%K{000} %F{015}disconnected %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unalias dig

  dig() {
    echo "second"
  }

  # Segment should not have changed!
  assertEquals "%K{000} %F{015}second %k%F{000}%f " "$(__p9k_build_left_prompt)"

  unfunction dig
}

source shunit2/shunit2
