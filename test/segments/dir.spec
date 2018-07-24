#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source functions/*
  source segments/dir.p9k

  # Every test should at least use the dir segment
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
}

function tearDown() {
  unset P9K_LEFT_PROMPT_ELEMENTS
}

function testDirPathAbsoluteWorks() {
  local P9K_DIR_PATH_ABSOLUTE=true

  cd ~
  assertEquals "%K{blue} %F{black}/home/travis %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testTruncateFoldersWorks() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_folders'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}…/12345678/123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateFolderWithHomeDirWorks() {
  local P9K_DIR_SHORTEN_LENGTH=1
  local CURRENT_DIR=$(pwd)

  cd ~
  local FOLDER="powerlevel9k-test-${RANDOM}"
  mkdir -p $FOLDER
  cd $FOLDER
  # Switch back to home folder as this causes the problem.
  cd ..

  assertEquals "%K{blue} %F{black}~ %k%F{blue}%f " "$(buildLeftPrompt)"

  rmdir $FOLDER
  cd ${CURRENT_DIR}
}

function testTruncateMiddleWorks() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_middle'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}/tmp/po…st/1/12/123/1234/12…45/12…56/12…67/12…78/123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncationFromRightWorks() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_right'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}/tmp/po…/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateToLastWorks() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY="truncate_to_last"

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateToFirstAndLastWorks() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY="truncate_to_first_and_last"

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}/tmp/powerlevel9k-test/…/…/…/…/…/…/…/12345678/123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateAbsoluteWorks() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY="truncate_absolute"

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}…89 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncationFromRightWithEmptyDelimiter() {
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_DELIMITER=""
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_right'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}/tmp/po/1/12/123/12/12/12/12/12/123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateWithFolderMarkerWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.shorten_folder_marker
  cd $FOLDER
  assertEquals "%K{blue} %F{black}/…/12/123/1234/12345/123456/1234567 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr $BASEFOLDER
}

function testTruncateWithFolderMarkerWithChangedFolderMarker() {
  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"
  local P9K_DIR_SHORTEN_FOLDER_MARKER='.xxx'

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.xxx
  cd $FOLDER
  assertEquals "%K{blue} %F{black}/…/12/123/1234/12345/123456/1234567 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameWorks() {
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER

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

  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'

  assertEquals "%K{blue} %F{black}My_Package/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{blue}%f " "$(buildLeftPrompt)"

  # Go back
  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameIfRepoIsSymlinkedInsideDeepFolder() {
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  # Unfortunately: The main folder must be a git repo..
  git init &>/dev/null

  echo '
{
  "name": "My_Package"
}
' > package.json

  # Create a subdir inside the repo
  mkdir -p asdfasdf/qwerqwer

  cd $BASEFOLDER
  ln -s ${FOLDER} linked-repo

  # Go to deep folder inside linked repo
  cd linked-repo/asdfasdf/qwerqwer

  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'

  assertEquals "%K{blue} %F{black}My_Package/as…/qwerqwer %k%F{blue}%f " "$(buildLeftPrompt)"

  # Go back
  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameIfRepoIsSymlinkedInsideGitDir() {
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  # Unfortunately: The main folder must be a git repo..
  git init &>/dev/null

  echo '
{
  "name": "My_Package"
}
' > package.json

  cd $BASEFOLDER
  ln -s ${FOLDER} linked-repo

  cd linked-repo/.git/refs/heads

  local -a P9K_LEFT_PROMPT_ELEMENTS; P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'

  assertEquals "%K{blue} %F{black}My_Package/.g…/re…/heads %k%F{blue}%f " "$(buildLeftPrompt)"

  # Go back
  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testHomeFolderDetectionWorks() {
  local P9K_DIR_HOME_ICON='*home-icon'

  # Re-Source the dir segment
  source segments/dir.p9k

  cd ~
  assertEquals "%K{blue} %F{black}*home-icon %f%F{black}~ %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testHomeSubfolderDetectionWorks() {
  local P9K_DIR_HOME_SUBFOLDER_ICON='*sub-icon'

  # Re-Source the dir segment
  source segments/dir.p9k

  local FOLDER=~/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER
  assertEquals "%K{blue} %F{black}*sub-icon %f%F{black}~/powerlevel9k-test %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr $FOLDER
}

function testOtherFolderDetectionWorks() {
  local P9K_DIR_DEFAULT_ICON='*folder-icon'

  # Re-Source the dir segment
  source segments/dir.p9k

  local FOLDER=/tmp/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER
  assertEquals "%K{blue} %F{black}*folder-icon %f%F{black}/tmp/powerlevel9k-test %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr $FOLDER
}

function testChangingDirPathSeparator() {
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local FOLDER="/tmp/powerlevel9k-test/1/2"
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{blue} %F{black}xXxtmpxXxpowerlevel9k-testxXx1xXx2 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testHomeFolderAbbreviation() {
  local P9K_DIR_HOME_FOLDER_ABBREVIATION
  local dir=$PWD

  cd ~/
  # default
  P9K_DIR_HOME_FOLDER_ABBREVIATION='~'
  assertEquals "%K{blue} %F{black}~ %k%F{blue}%f " "$(buildLeftPrompt)"

  # substituted
  P9K_DIR_HOME_FOLDER_ABBREVIATION='qQq'
  assertEquals "%K{blue} %F{black}qQq %k%F{blue}%f " "$(buildLeftPrompt)"

  cd /tmp
  # default
  P9K_DIR_HOME_FOLDER_ABBREVIATION='~'
  assertEquals "%K{blue} %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  # substituted
  P9K_DIR_HOME_FOLDER_ABBREVIATION='qQq'
  assertEquals "%K{blue} %F{black}/tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd "$dir"
}

function testOmittingFirstCharacterWorks() {
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_DEFAULT_ICON='*folder-icon'

  # Re-Source the dir segment
  source segments/dir.p9k

  cd /tmp

  assertEquals "%K{blue} %F{black}*folder-icon %f%F{black}tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testOmittingFirstCharacterWorksWithChangingPathSeparator() {
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_DEFAULT_ICON='*folder-icon'

  # Re-Source the dir segment
  source segments/dir.p9k

  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}*folder-icon %f%F{black}tmpxXxpowerlevel9k-testxXx1xXx2 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

# This test makes it obvious that combining a truncation strategy
# that cuts off folders from the left and omitting the the first
# character does not make much sense. The truncation strategy
# comes first, prints an ellipsis and that gets then cut off by
# P9K_DIR_OMIT_FIRST_CHARACTER..
# But it does more sense in combination with other truncation
# strategies.
function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndDefaultTruncation() {
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_folders'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}xXx1xXx2 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndMiddleTruncation() {
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_middle'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}tmpxXxpo…stxXx1xXx2 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndRightTruncation() {
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_right'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{blue} %F{black}tmpxXxpo…xXx1xXx2 %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateToUniqueWorks() {
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_to_unique'
  local P9K_DIR_PATH_ABSOLUTE=true
  mkdir -p /tmp/powerlevel9k-test/adam/devl
  mkdir -p /tmp/powerlevel9k-test/alice/devl
  mkdir -p /tmp/powerlevel9k-test/alice/docs
  mkdir -p /tmp/powerlevel9k-test/bob/docs
  cd /tmp/powerlevel9k-test/alice/devl

  assertEquals "%K{blue} %F{black}txXxpxXxalxXxde %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBoldHomeDirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  cd ~

  assertEquals "%K{blue} %F{black}%B~%b %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testBoldHomeSubdirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  mkdir -p ~/powerlevel9k-test
  cd ~/powerlevel9k-test

  assertEquals "%K{blue} %F{black}~/%Bpowerlevel9k-test%b %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr ~/powerlevel9k-test
}

function testBoldRootDirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  cd /

  assertEquals "%K{blue} %F{black}%B/%b %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testBoldRootSubdirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  cd /tmp

  assertEquals "%K{blue} %F{black}/%Btmp%b %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testBoldRootSubSubdirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  mkdir -p /tmp/powerlevel9k-test
  cd /tmp/powerlevel9k-test

  assertEquals "%K{blue} %F{black}/tmp/%Bpowerlevel9k-test%b %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testHighlightHomeWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  cd ~

  assertEquals "%K{blue} %F{black}%F{red}~ %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testHighlightHomeSubdirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  mkdir -p ~/powerlevel9k-test
  cd ~/powerlevel9k-test

  assertEquals "%K{blue} %F{black}~/%F{red}powerlevel9k-test %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr ~/powerlevel9k-test
}

function testHighlightRootWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  cd /

  assertEquals "%K{blue} %F{black}%F{red}/ %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testHighlightRootSubdirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  cd /tmp

  assertEquals "%K{blue} %F{black}/%F{red}tmp %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
}

function testHighlightRootSubSubdirWorks() {
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  mkdir /tmp/powerlevel9k-test
  cd /tmp/powerlevel9k-test

  assertEquals "%K{blue} %F{black}/tmp/%F{red}powerlevel9k-test %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testDirSeparatorColorHomeSubdirWorks() {
  local P9K_DIR_PATH_SEPARATOR_FOREGROUND='red'
  mkdir -p ~/powerlevel9k-test
  cd ~/powerlevel9k-test

  assertEquals "%K{blue} %F{black}~%F{red}/%F{black}powerlevel9k-test %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr ~/powerlevel9k-test
}

function testDirSeparatorColorRootSubSubdirWorks() {
  local P9K_DIR_PATH_SEPARATOR_FOREGROUND='red'
  mkdir -p /tmp/powerlevel9k-test
  cd /tmp/powerlevel9k-test

  assertEquals "%K{blue} %F{black}%F{red}/%F{black}tmp%F{red}/%F{black}powerlevel9k-test %k%F{blue}%f " "$(buildLeftPrompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

source shunit2/source/2.1/src/shunit2
