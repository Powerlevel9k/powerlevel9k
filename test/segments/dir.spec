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
  FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
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

  p9k_clear_cache
}

function testTruncateFoldersWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_folders'

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}%3(c:…/:)%2c %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testTruncateMiddleWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_middle'

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}/tmp/po…st/1/12/123/1234/12…45/12…56/12…67/12…78/123456789 %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testTruncateWithPackageNameWorks() {
  cd /tmp/powerlevel9k-test
  echo '
{
  "name": "My_Package"
}
' > package.json
  # Unfortunately: The main folder must be a git repo..
  git init &>/dev/null

  # Go back to deeper folder
  cd "${FOLDER}"

  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_with_package_name'

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{blue} %F{black}My_Package/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHORTEN_STRATEGY
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
}

# TODO: Unskip test
function testTruncateWithPackageNameInComplexPackageJsonWorks() {
  # Skip test, as at the moment, we do not parse the right name.
  # This is a feature done in another pull request.
  startSkipping # Skip test

  cd /tmp/powerlevel9k-test
  echo '
{
  "author": {
    "name": "Cookiemonster"
  },
  "name": "My_Package"
}
' > package.json
  # Unfortunately: The main folder must be a git repo..
  git init &>/dev/null

  # Go back to deeper folder
  cd "${FOLDER}"

  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_with_package_name'

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{blue} %F{black}My_Package/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHORTEN_STRATEGY
  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
}

function testTruncationFromRightWorks() {
  POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black}/tmp/po…/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHORTEN_DIR_LENGTH
  unset POWERLEVEL9K_SHORTEN_STRATEGY
}

function testHomeFolderDetectionWorks() {
  POWERLEVEL9K_HOME_ICON='home-icon'

  cd ~
  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}home-icon%f %F{black}%~ %k%F{blue}%f " "${PROMPT}"

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

  unset POWERLEVEL9K_HOME_SUB_ICON
}

function testOtherFolderDetectionWorks() {
  POWERLEVEL9K_FOLDER_ICON='folder-icon'

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black%}folder-icon%f %F{black}%~ %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_FOLDER_ICON
}

function testPathSeparatorIsCustomizable() {
  POWERLEVEL9K_DIR_PATH_SEPARATOR=' S '

  prompt_dir "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{blue} %F{black} S tmp S powerlevel9k-test S 1 S 12 S 123 S 1234 S 12345 S 123456 S 1234567 S 12345678 S 123456789 %k%F{blue}%f " "${PROMPT}"

  unset POWERLEVEL9K_DIR_PATH_SEPARATOR
}

source shunit2/source/2.1/src/shunit2