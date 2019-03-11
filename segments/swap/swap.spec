#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test/swap-test

  source "${P9K_HOME}/powerlevel9k.zsh-theme"
  source "${P9K_HOME}/segments/swap/swap.p9k"

  mkdir -p "${FOLDER}"
  cd $FOLDER
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
}

function testSwapSegmentWorksOnOsx() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(swap)
  sysctl() {
    echo "vm.swapusage: total = 3072,00M  used = 1620,50M  free = 1451,50M  (encrypted)"
  }

  local __P9K_OS="OSX" # Fake OSX

  assertEquals "%K{003} %F{000}SWP %F{000}1.58G " "$(prompt_swap left 1 false ${FOLDER})"

  unfunction sysctl
}

function testSwapSegmentWorksOnLinux() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(swap)
  mkdir proc
  echo "SwapTotal: 1000000" > proc/meminfo
  echo "SwapFree: 1000" >> proc/meminfo

  local __P9K_OS="Linux" # Fake Linux

  assertEquals "%K{003} %F{000}SWP %F{000}0.95G " "$(prompt_swap left 1 false ${FOLDER})"
}

source shunit2/shunit2
