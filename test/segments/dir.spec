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
}

function tearDown() {
  p9k_clear_cache
}

function testTruncateFoldersWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_folders'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}%3(c:…/:)%2c %k%F{blue}%f " "${PROMPT}"

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

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}/tmp/po…st/1/12/123/1234/12…45/12…56/12…67/12…78/123456789 %k%F{blue}%f " "${PROMPT}"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset FOLDER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testTruncationFromRightWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'

  FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}/tmp/po…/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "${PROMPT}"

  cd -
  rm -fr /tmp/powerlevel9k-test

  unset FOLDER
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testHomeFolderDetectionWorks() {
  POWERLEVEL9K_HOME_ICON='home-icon'

  cd ~
  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}home-icon%f %F{black}%~ %k%F{blue}%f " "${PROMPT}"

  cd -
  unset POWERLEVEL9K_HOME_ICON
}

function testHomeSubfolderDetectionWorks() {
  POWERLEVEL9K_HOME_SUB_ICON='sub-icon'

  FOLDER=~/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}sub-icon%f %F{black}%~ %k%F{blue}%f " "${PROMPT}"

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

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}folder-icon%f %F{black}%~ %k%F{blue}%f " "${PROMPT}"

  cd -
  rm -fr $FOLDER
  unset FOLDER
  unset POWERLEVEL9K_FOLDER_ICON
}

source shunit2/source/2.1/src/shunit2
