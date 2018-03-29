#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/developer/vcs.p9k
}

function testColorOverridingForCleanStateWorks() {
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  P9K_VCS_CLEAN_FOREGROUND='cyan'
  P9K_VCS_CLEAN_BACKGROUND='white'

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null

  assertEquals "%K{white} %F{cyan} master %k%F{white}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_VCS_CLEAN_FOREGROUND
  unset P9K_VCS_CLEAN_BACKGROUND
}

function testColorOverridingForModifiedStateWorks() {
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  P9K_VCS_MODIFIED_FOREGROUND='red'
  P9K_VCS_MODIFIED_BACKGROUND='yellow'

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

  assertEquals "%K{yellow} %F{red} master ● %k%F{yellow}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_VCS_MODIFIED_FOREGROUND
  unset P9K_VCS_MODIFIED_BACKGROUND
}

function testColorOverridingForUntrackedStateWorks() {
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  P9K_VCS_UNTRACKED_FOREGROUND='cyan'
  P9K_VCS_UNTRACKED_BACKGROUND='yellow'

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{yellow} %F{cyan} master ? %k%F{yellow}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset P9K_LEFT_PROMPT_ELEMENTS
  unset P9K_VCS_UNTRACKED_FOREGROUND
  unset P9K_VCS_UNTRACKED_BACKGROUND
}

source shunit2/source/2.1/src/shunit2
