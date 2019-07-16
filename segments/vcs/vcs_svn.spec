#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and hg init it.
  BASEFOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p "${BASEFOLDER}"

  # Setup a SVN folder
  svnadmin create ${BASEFOLDER}/svn-repo
  FOLDER=${BASEFOLDER}/svn-checkout
  mkdir ${FOLDER}
  REPO_URL="file://${BASEFOLDER}/svn-repo"
  svn checkout "${REPO_URL}" "${FOLDER}" >/dev/null
  cd ${FOLDER}
  echo "TEST" >> testfile
  svn add testfile >/dev/null
  svn commit -m "Initial commit" >/dev/null

  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}" &>/dev/null
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test &>/dev/null
  unset FOLDER
  unset BASEFOLDER
  unset P9K_HOME
  unset REPO_URL
}

function testVcsSegmentDoesNotLeakPercentEscapesInSvnRepo() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  source "${P9K_HOME}/segments/vcs/vcs.p9k"

  local branchFolder='../%E%K{red}'
  svn checkout "${REPO_URL}" "${branchFolder}" >/dev/null
  cd "${branchFolder}"

  assertEquals "%K{002} %F{000}\${(Q)\${:-\"svn-repo:1\"}} %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2