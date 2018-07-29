#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/vcs.p9k
}

function testColorOverridingForCleanStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_CLEAN_FOREGROUND='cyan'
  local P9K_VCS_CLEAN_BACKGROUND='white'
  source segments/vcs.p9k

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null

  assertEquals "%K{white} %F{cyan} master %k%F{white}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testColorOverridingForModifiedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
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

  assertEquals "%K{yellow} %F{red} master ● %k%F{yellow}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testColorOverridingForUntrackedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNTRACKED_FOREGROUND='cyan'
  local P9K_VCS_UNTRACKED_BACKGROUND='yellow'
  source segments/vcs.p9k

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{yellow} %F{cyan} master ? %k%F{yellow}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=6
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(buildLeftPrompt)"

  P9K_VCS_SHORTEN_LENGTH=3
  assertEquals "%K{green} %F{black} mas… ? %k%F{green}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingMinLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=6
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(buildLeftPrompt)"

  P9K_VCS_SHORTEN_MIN_LENGTH=7

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenStrategy() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{green} %F{black} mas… ? %k%F{green}%f " "$(buildLeftPrompt)"

  P9K_VCS_SHORTEN_STRATEGY="truncate_middle"

  assertEquals "%K{green} %F{black} mas…ter ? %k%F{green}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=6
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(buildLeftPrompt)"

  P9K_VCS_SHORTEN_LENGTH=3
  assertEquals "%K{green} %F{black} mas… ? %k%F{green}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingMinLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=6
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(buildLeftPrompt)"

  P9K_VCS_SHORTEN_MIN_LENGTH=7

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenStrategy() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"

  local FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{green} %F{black} mas… ? %k%F{green}%f " "$(buildLeftPrompt)"

  P9K_VCS_SHORTEN_STRATEGY="truncate_middle"

  assertEquals "%K{green} %F{black} mas…ter ? %k%F{green}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

source shunit2/source/2.1/src/shunit2
