#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUpOnce() {
  source functions/autoload/__p9k_upsearch
}

function setUp() {
  export TERM="xterm-256color"
  P9K_HOME="${PWD}"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source segments/dir/dir.p9k
}

function tearDown() {
  unset P9K_HOME
}

function testDirPathAbsoluteWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_ABSOLUTE=true

  cd ~
  local absoluteDir="${PWD}"
  assertEquals "%K{004} %F{000}${absoluteDir} %k%F{004}%f " "$(__p9k_build_left_prompt)"

  local P9K_DIR_PATH_ABSOLUTE=false
  assertEquals "%K{004} %F{000}~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  typeset -a _strategies
  # Do not check truncate_to_last and truncate_to_unique
  _strategies=( truncate_from_left truncate_from_right truncate_middle truncate_to_first_and_last truncate_absolute truncate_with_folder_marker truncate_with_package_name )

  for strategy in ${_strategies}; do
    local P9K_DIR_PATH_ABSOLUTE=true
    P9K_DIR_SHORTEN_STRATEGY=${strategy}
    assertEquals "${strategy} failed rendering absolute dir" "%K{004} %F{000}${absoluteDir} %k%F{004}%f " "$(__p9k_build_left_prompt)"

    local P9K_DIR_PATH_ABSOLUTE=false
    assertEquals "${strategy} failed rendering relative dir" "%K{004} %F{000}~ %k%F{004}%f " "$(__p9k_build_left_prompt)"
  done
  cd -
}

function testTruncateFoldersWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_folders'
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}…/12345678/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateFolderWithHomeDirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=1
  local CURRENT_DIR=$(pwd)

  cd ~
  local FOLDER="powerlevel9k-test-${RANDOM}"
  mkdir -p $FOLDER
  cd $FOLDER
  # Switch back to home folder as this causes the problem.
  cd ..

  assertEquals "%K{004} %F{000}~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  rmdir $FOLDER
  cd ${CURRENT_DIR}
}

function testTruncationFromRightWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_right'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}/tmp/po…/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateMiddleWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_middle'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}/tmp/po…st/1/12/123/1234/12…45/12…56/12…67/12…78/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncationFromLeftWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_left'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}/tmp/…st/1/12/123/…34/…45/…56/…67/…78/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateToLastWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY="truncate_to_last"

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateToFirstAndLastWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY="truncate_to_first_and_last"

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}/tmp/powerlevel9k-test/…/…/…/…/…/…/…/12345678/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateAbsoluteWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY="truncate_absolute"

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}…89 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncationFromRightWithEmptyDelimiter() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_DELIMITER=""
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_right'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}/tmp/po/1/12/123/12/12/12/12/12/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncationFromLeftWithEmptyDelimiter() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_DELIMITER=""
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_left'

  local FOLDER=/tmp/powerlevel9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}/tmp/st/1/12/123/34/45/56/67/78/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateWithFolderMarkerWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.shorten_folder_marker
  cd $FOLDER
  assertEquals "%K{004} %F{000}/…/12/123/1234/12345/123456/1234567 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
}

function testTruncateWithFolderMarkerInHome() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"

  local BASEFOLDER=/tmp/powerlevel9k-test
  local SAVED_HOME=$HOME
  HOME=$BASEFOLDER

  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.shorten_folder_marker
  cd $FOLDER
  assertEquals "%K{004} %F{000}~/…/12/123/1234/12345/123456/1234567 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  HOME=$SAVED_HOME
}

function testTruncateWithFolderMarkerWithChangedFolderMarker() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"
  local P9K_DIR_SHORTEN_FOLDER_MARKER='.xxx'

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.xxx
  cd $FOLDER
  assertEquals "%K{004} %F{000}/…/12/123/1234/12345/123456/1234567 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
}

function testTruncateWithFolderMarkerWithSymlinks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567
  mkdir -p $FOLDER
  # Setup folder marker
  touch $BASEFOLDER/1/12/.shorten_folder_marker
  ln -sf ${BASEFOLDER}/1 ${BASEFOLDER}/link
  ln -sf ${BASEFOLDER}/1/12/123 ${BASEFOLDER}/link2
  ln -sf ${BASEFOLDER}/1/12/123/1234/12345 ${BASEFOLDER}/1/12/123/link3
  cd ${BASEFOLDER}/link
  assertEquals "%K{004} %F{000}/tmp/powerlevel9k-test/link %k%F{004}%f " "$(__p9k_build_left_prompt)"
  cd -
  cd ${BASEFOLDER}/link2
  assertEquals "%K{004} %F{000}/tmp/powerlevel9k-test/link2 %k%F{004}%f " "$(__p9k_build_left_prompt)"
  cd -
  cd ${BASEFOLDER}/1/12/123/link3
  assertEquals "%K{004} %F{000}/…/12/123/link3 %k%F{004}%f " "$(__p9k_build_left_prompt)"
  cd -

  rm -fr $BASEFOLDER
}

function testTruncateWithFolderMarkerInMarkedFolder() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_SHORTEN_STRATEGY="truncate_with_folder_marker"

  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12
  mkdir -p $FOLDER
  # Setup folder marker
  touch $FOLDER/.shorten_folder_marker
  cd $FOLDER
  # setopt xtrace
  assertEquals "%K{004} %F{000}/…/12 %k%F{004}%f " "$(__p9k_build_left_prompt)"
  # unsetopt xtrace

  cd -
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
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

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'

  assertEquals "%K{004} %F{000}My_Package/1/12/123/12…/12…/12…/12…/12…/123456789 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  # Go back
  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameIfRepoIsSymlinkedInsideDeepFolder() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
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

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'

  assertEquals "%K{004} %F{000}My_Package/as…/qwerqwer %k%F{004}%f " "$(__p9k_build_left_prompt)"

  # Go back
  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameIfRepoIsSymlinkedInsideGitDir() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
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

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'

  assertEquals "%K{004} %F{000}My_Package/.g…/re…/heads %k%F{004}%f " "$(__p9k_build_left_prompt)"

  # Go back
  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameFallsBackToGit() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789/My_Repo
  mkdir -p $FOLDER

  cd "${FOLDER}"
  git init &>/dev/null
  mkdir -p 0/12/345/6789/abcde/f
  cd 0/12/345/6789/abcde/f

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'
  local P9K_DIR_SHORTEN_GIT_FALLBACK=true

  assertEquals "%K{004} %F{000}My_Repo/0/12/345/67…/ab…/f %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameFallsBackToGitAndUsesRemote() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789/My_Repo
  mkdir -p $FOLDER

  cd "${FOLDER}"
  git init &>/dev/null
  git remote add origin http://localhost/Remote_Repo.git
  mkdir -p 0/12/345/6789/abcde/f
  cd 0/12/345/6789/abcde/f

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'
  local P9K_DIR_SHORTEN_GIT_FALLBACK=true
  local P9K_DIR_SHORTEN_GIT_FALLBACK_USE_REMOTE=true

  assertEquals "%K{004} %F{000}Remote_Repo/0/12/345/67…/ab…/f %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameFallsBackToGitAndUsesAltRemote() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789/My_Repo
  mkdir -p $FOLDER

  cd "${FOLDER}"
  git init &>/dev/null
  git remote add origin http://localhost/Remote_Repo.git
  git remote add upstream http://localhost/Upstream_Repo.git
  mkdir -p 0/12/345/6789/abcde/f
  cd 0/12/345/6789/abcde/f

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'
  local P9K_DIR_SHORTEN_GIT_FALLBACK=true
  local P9K_DIR_SHORTEN_GIT_FALLBACK_USE_REMOTE=true
  local P9K_DIR_SHORTEN_GIT_FALLBACK_REMOTE_NAME=upstream

  assertEquals "%K{004} %F{000}Upstream_Repo/0/12/345/67…/ab…/f %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testTruncateWithPackageNameFallsBackToGitAndHandlesMissingRemote {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local p9kFolder=$(pwd)
  local BASEFOLDER=/tmp/powerlevel9k-test
  local FOLDER=$BASEFOLDER/1/12/123/1234/12345/123456/1234567/12345678/123456789/My_Repo
  mkdir -p $FOLDER

  cd "${FOLDER}"
  git init &>/dev/null
  git remote add origin http://localhost/Remote_Repo.git
  mkdir -p 0/12/345/6789/abcde/f
  cd 0/12/345/6789/abcde/f

  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_with_package_name'
  local P9K_DIR_SHORTEN_GIT_FALLBACK=true
  local P9K_DIR_SHORTEN_GIT_FALLBACK_USE_REMOTE=true
  local P9K_DIR_SHORTEN_GIT_FALLBACK_REMOTE_NAME=upstream

  assertEquals "%K{004} %F{000}My_Repo/0/12/345/67…/ab…/f %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd $p9kFolder
  rm -fr $BASEFOLDER
}

function testHomeFolderDetectionWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_HOME_ICON='home-icon'
  # re-source the segment to register updates
  source segments/dir/dir.p9k

  cd ~
  assertEquals "%K{004} %F{000}home-icon %F{000}~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testHomeSubfolderDetectionWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_HOME_SUBFOLDER_ICON='sub-icon'
  # re-source the segment to register updates
  source segments/dir/dir.p9k

  local FOLDER=~/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER
  assertEquals "%K{004} %F{000}sub-icon %F{000}~/powerlevel9k-test %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $FOLDER
}

function testOtherFolderDetectionWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON='folder-icon'
  # re-source the segment to register updates
  source segments/dir/dir.p9k

  local FOLDER=/tmp/powerlevel9k-test
  mkdir $FOLDER
  cd $FOLDER
  assertEquals "%K{004} %F{000}folder-icon %F{000}/tmp/powerlevel9k-test %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $FOLDER
}

function testChangingDirPathSeparator() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local FOLDER="/tmp/powerlevel9k-test/1/2"
  mkdir -p $FOLDER
  cd $FOLDER

  assertEquals "%K{004} %F{000}xXxtmpxXxpowerlevel9k-testxXx1xXx2 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testHomeFolderAbbreviation() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_HOME_FOLDER_ABBREVIATION

  local dir=$PWD

  local BASEFOLDER=/tmp/p9ktest
  local SAVED_HOME="${HOME}"
  HOME="${BASEFOLDER}"
  mkdir -p "$HOME"

  cd ~/
  # default
  local P9K_DIR_HOME_FOLDER_ABBREVIATION='~'
  assertEquals "%K{004} %F{000}~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  # substituted
  local P9K_DIR_HOME_FOLDER_ABBREVIATION='qQq'
  assertEquals "%K{004} %F{000}qQq %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd /tmp
  # default
  local P9K_DIR_HOME_FOLDER_ABBREVIATION='~'
  assertEquals "%K{004} %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  # substituted
  local P9K_DIR_HOME_FOLDER_ABBREVIATION='qQq'
  assertEquals "%K{004} %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  # Make a directory named tilde directly under HOME
  mkdir ~/~
  cd ~/~
  local P9K_DIR_HOME_FOLDER_ABBREVIATION='qQq'
  assertEquals "%K{004} %F{000}qQq/~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  HOME="${SAVED_HOME}"
  rm -fr $BASEFOLDER
  cd "$dir"
}

function testOmittingFirstCharacterWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_DEFAULT_ICON='folder-icon'
  # re-source the segment to register updates
  source segments/dir/dir.p9k

  cd /tmp

  assertEquals "%K{004} %F{000}folder-icon %F{000}tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testOmittingFirstCharacterWorksWithChangingPathSeparator() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_DEFAULT_ICON='folder-icon'
  # re-source the segment to register updates
  source segments/dir/dir.p9k

  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{004} %F{000}folder-icon %F{000}tmpxXxpowerlevel9k-testxXx1xXx2 %k%F{004}%f " "$(__p9k_build_left_prompt)"

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
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_folders'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{004} %F{000}xXx1xXx2 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndMiddleTruncation() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_middle'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{004} %F{000}tmpxXxpo…stxXx1xXx2 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testOmittingFirstCharacterWorksWithChangingPathSeparatorAndRightTruncation() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_from_right'
  mkdir -p /tmp/powerlevel9k-test/1/2
  cd /tmp/powerlevel9k-test/1/2

  assertEquals "%K{004} %F{000}tmpxXxpo…xXx1xXx2 %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testTruncateToUniqueWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_SEPARATOR='xXx'
  local P9K_DIR_SHORTEN_LENGTH=2
  local P9K_DIR_SHORTEN_STRATEGY='truncate_to_unique'

  mkdir -p /tmp/powerlevel9k-test/adam/devl
  mkdir -p /tmp/powerlevel9k-test/alice/devl
  mkdir -p /tmp/powerlevel9k-test/alice/docs
  mkdir -p /tmp/powerlevel9k-test/bob/docs

  # get unique name for tmp folder - on macOS, this is /private/tmp
  cd /tmp/powerlevel9k-test
  local test_path=${$(__p9k_get_unique_path $PWD:A)//\//$P9K_DIR_PATH_SEPARATOR}
  cd -

  cd /tmp/powerlevel9k-test/alice/devl

  assertEquals "%K{004} %F{000}${test_path}xXxalxXxde %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBoldHomeDirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  cd ~

  assertEquals "%K{004} %F{000}%B~%b %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testBoldHomeSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  mkdir -p ~/powerlevel9k-test
  cd ~/powerlevel9k-test

  assertEquals "%K{004} %F{000}~/%Bpowerlevel9k-test%b %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr ~/powerlevel9k-test
}

function testBoldRootDirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  cd /

  assertEquals "%K{004} %F{000}%B/%b %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testBoldRootSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  cd /tmp

  assertEquals "%K{004} %F{000}/%Btmp%b %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testBoldRootSubSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true
  mkdir -p /tmp/powerlevel9k-test
  cd /tmp/powerlevel9k-test

  assertEquals "%K{004} %F{000}/tmp/%Bpowerlevel9k-test%b %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testHighlightHomeWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  cd ~

  assertEquals "%K{004} %F{000}%F{001}~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testHighlightHomeSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  mkdir -p ~/powerlevel9k-test
  cd ~/powerlevel9k-test

  assertEquals "%K{004} %F{000}~/%F{001}powerlevel9k-test %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr ~/powerlevel9k-test
}

function testHighlightRootWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  cd /

  assertEquals "%K{004} %F{000}%F{001}/ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testHighlightRootSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  cd /tmp

  assertEquals "%K{004} %F{000}/%F{001}tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testHighlightRootSubSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_HIGHLIGHT_FOREGROUND='red'
  mkdir /tmp/powerlevel9k-test
  cd /tmp/powerlevel9k-test

  assertEquals "%K{004} %F{000}/tmp/%F{001}powerlevel9k-test %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testDirSeparatorColorHomeSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_SEPARATOR_FOREGROUND='red'
  mkdir -p ~/powerlevel9k-test
  cd ~/powerlevel9k-test

  assertEquals "%K{004} %F{000}~%F{001}/%F{000}powerlevel9k-test %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr ~/powerlevel9k-test
}

function testDirSeparatorColorRootSubSubdirWorks() {
  typeset -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_PATH_SEPARATOR_FOREGROUND='red'
  mkdir -p /tmp/powerlevel9k-test
  cd /tmp/powerlevel9k-test

  assertEquals "%K{004} %F{000}%F{001}/%F{000}tmp%F{001}/%F{000}powerlevel9k-test %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testDirHomeTruncationWorksOnlyAtTheBeginning() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)

  local FOLDER=/tmp/p9ktest
  local SAVED_HOME="${HOME}"
  HOME="/p9ktest"

  mkdir -p $FOLDER
  # Setup folder marker
  cd $FOLDER
  assertEquals "%K{004} %F{000}/tmp/p9ktest %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $FOLDER
  HOME="${SAVED_HOME}"
}

function testDirSegmentWithDirectoryThatContainsFormattingInstructions() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)

  local BASEFOLDER=/tmp/p9ktest
  local FOLDER=${BASEFOLDER}/\'%E%K{red}\'
  local SAVED_HOME="${HOME}"
  HOME="${BASEFOLDER}"

  mkdir -p $FOLDER
  cd $FOLDER
  assertEquals "%K{004} %F{000}~/'%%E%%K{red}' %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  HOME="${SAVED_HOME}"
}

function testDirSegmentWithDirectoryNamedTilde() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)

  local BASEFOLDER=/tmp/p9ktest
  local FOLDER=${BASEFOLDER}/\~/\~
  local SAVED_HOME="${HOME}"
  HOME="${BASEFOLDER}"

  mkdir -p $FOLDER
  cd $FOLDER
  assertEquals "%K{004} %F{000}~/~/~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  HOME="${SAVED_HOME}"
}

function testDirSegmentWithDirectoryNamedTildeOmittingFirstCharacter() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true

  local BASEFOLDER=/tmp/p9ktest
  local FOLDER=${BASEFOLDER}/\~
  local SAVED_HOME="${HOME}"
  HOME="${BASEFOLDER}"

  mkdir -p $FOLDER
  cd $FOLDER
  assertEquals "%K{004} %F{000}/~ %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  HOME="${SAVED_HOME}"
}

function testDirSegmentWithDirectoryNamedTildeOmittingFirstCharacterInBoldMode() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_OMIT_FIRST_CHARACTER=true
  local P9K_DIR_PATH_HIGHLIGHT_BOLD=true

  local BASEFOLDER=/tmp/p9ktest
  local FOLDER=${BASEFOLDER}/\~
  local SAVED_HOME="${HOME}"
  HOME="${BASEFOLDER}"

  mkdir -p $FOLDER
  cd $FOLDER
  assertEquals "%K{004} %F{000}/%B~%b %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr $BASEFOLDER
  HOME="${SAVED_HOME}"
}

source shunit2/shunit2
