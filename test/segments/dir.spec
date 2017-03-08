#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme

  # Every test should at least use the dir segment
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir)
}

function tearDown() {
  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
}

function testTruncateFoldersWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_folders'

  FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}…/12345678/123456789 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset FOLDER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testTruncateMiddleWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_middle'

  FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}/tmp/po…st/1/12/123/1234/12…45/12…56/12…67/12…78/123456789 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset FOLDER
  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testTruncationFromRightWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'

  FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}/tmp/po…/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset FOLDER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testTruncateWithFolderMarkerWorks() {
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir)
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_with_folder_marker"

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.shorten_folder_marker
  cd $FOLDER
  assertEquals "%K{blue} %F{black}/…/12/123/1234/12345/123456/1234567 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  unset BASEFOLDER
  unset FOLDER
  unset POWERLEVEL9K_SHORTEN_STRATEGY
  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
}

function testTruncateWithFolderMarkerWithChangedFolderMarker() {
  POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir)
  POWERLEVEL9K_SHORTEN_STRATEGY="truncate_with_folder_marker"
  POWERLEVEL9K_SHORTEN_FOLDER_MARKER='.xxx'

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.xxx
  cd $FOLDER
  assertEquals "%K{blue} %F{black}/…/12/123/1234/12345/123456/1234567 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  unset BASEFOLDER
  unset FOLDER
  unset POWERLEVEL9K_SHORTEN_FOLDER_MARKER
  unset POWERLEVEL9K_SHORTEN_STRATEGY
  unset POWERLEVEL9K_LEFT_PROMPT_ELEMENTS
}

function testHomeFolderDetectionWorks() {
  POWERLEVEL9K_HOME_ICON='home-icon'

  cd ~
  assertEquals "%K{blue} %F{black%}home-icon%f %F{black}~ %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  unset POWERLEVEL9K_HOME_ICON
}

function testHomeSubfolderDetectionWorks() {
  POWERLEVEL9K_HOME_SUB_ICON='sub-icon'

  FOLDER=~/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER
  assertEquals "%K{blue} %F{black%}sub-icon%f %F{black}~/powerlevel9k-test %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr $FOLDER
  unset FOLDER
  unset POWERLEVEL9K_HOME_SUB_ICON
}

function testOtherFolderDetectionWorks() {
  POWERLEVEL9K_FOLDER_ICON='folder-icon'

  FOLDER=/tmp/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER
  assertEquals "%K{blue} %F{black%}folder-icon%f %F{black}/tmp/powerlevel9k-test %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr $FOLDER
  unset FOLDER
  unset POWERLEVEL9K_FOLDER_ICON
}

function testChangingDirPathSeparator() {
  POWERLEVEL9K_DIR_PATH_SEPARATOR='xXx'
  local FOLDER="/tmp/powerlevel9k-test/1/2"
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}xXxtmpxXxpowerlevel9k-testxXx1xXx2 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  unset FOLDER
  rm -fr /tmp/powerlevel9k-test
  unset POWERLEVEL9K_DIR_PATH_SEPARATOR
}

function testOmittingFirstCharacterWorks() {
  POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
  POWERLEVEL9K_FOLDER_ICON='folder-icon'
  cd /tmp

  assertEquals "%K{blue} %F{black%}folder-icon%f %F{black}tmp %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  unset POWERLEVEL9K_FOLDER_ICON
  unset POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER
}

function testOmittingFirstCharacterWorksWithChangingPathSeparator() {
  POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
  POWERLEVEL9K_DIR_PATH_SEPARATOR='xXx'
  POWERLEVEL9K_FOLDER_ICON='folder-icon'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black%}folder-icon%f %F{black}tmpxXxpowerlevel9k-testxXx1xXx2 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
  unset POWERLEVEL9K_FOLDER_ICON
  unset POWERLEVEL9K_DIR_PATH_SEPARATOR
  unset POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER
}

# This test makes it obvious that combining a truncation strategy
# that cuts off folders from the left and omitting the the first
# character does not make much sense. The truncation strategy
# comes first, prints an ellipsis and that gets then cut off by
# POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER..
# But it does more sense in combination with other truncation
# strategies.
function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndDefaultTruncation() {
  POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
  POWERLEVEL9K_DIR_PATH_SEPARATOR='xXx'
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_folders'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}xXx1xXx2 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
  unset POWERLEVEL9K_DIR_PATH_SEPARATOR
  unset POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndMiddleTruncation() {
  POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
  POWERLEVEL9K_DIR_PATH_SEPARATOR='xXx'
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_middle'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}tmpxXxpo…stxXx1xXx2 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
  unset POWERLEVEL9K_DIR_PATH_SEPARATOR
  unset POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndRightTruncation() {
  POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER=true
  POWERLEVEL9K_DIR_PATH_SEPARATOR='xXx'
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}tmpxXxpo…xXx1xXx2 %k%F{blue}%f " "$(build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
  unset POWERLEVEL9K_DIR_PATH_SEPARATOR
  unset POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

source shunit2/source/2.1/src/shunit2
