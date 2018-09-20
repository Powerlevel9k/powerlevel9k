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

function testColorOverridingForCleanStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_CLEAN_FOREGROUND='cyan'
  local P9K_VCS_CLEAN_BACKGROUND='white'
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null

  assertEquals "%K{015} %F{006} master %k%F{015}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testColorOverridingForModifiedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_MODIFIED_FOREGROUND='red'
  local P9K_VCS_MODIFIED_BACKGROUND='yellow'
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  git config user.email "test@powerlevel9k.theme"
  git config user.name  "Testing Tester"
  touch testfile
  git add testfile
  git commit -m "test" 1>/dev/null
  echo "test" > testfile

  assertEquals "%K{003} %F{001} master ● %k%F{003}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testColorOverridingForUntrackedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNTRACKED_FOREGROUND='cyan'
  local P9K_VCS_UNTRACKED_BACKGROUND='yellow'
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{003} %F{006} master ? %k%F{003}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=6
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{002} %F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_SHORTEN_LENGTH=3
  assertEquals "%K{002} %F{000} mas… ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingMinLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=6
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{002} %F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_SHORTEN_MIN_LENGTH=7

  assertEquals "%K{002} %F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenStrategy() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{002} %F{000} mas… ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_SHORTEN_STRATEGY="truncate_middle"

  assertEquals "%K{002} %F{000} mas…ter ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

source shunit2/shunit2
