#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"

  P9K_HOME=$(pwd)
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p "${FOLDER}"
  cd $FOLDER
  P9K_MODE=default

  # Set username and email
  OLD_GIT_AUTHOR_NAME=$GIT_AUTHOR_NAME
  GIT_AUTHOR_NAME="Testing Tester"
  OLD_GIT_AUTHOR_EMAIL=$GIT_AUTHOR_EMAIL
  GIT_AUTHOR_EMAIL="test@powerlevel9k.theme"

  # Set default username if not already set!
  if [[ -z $(git config user.name) ]]; then
    GIT_AUTHOR_NAME_SET_BY_TEST=true
    git config --global user.name "${GIT_AUTHOR_NAME}"
  fi
  # Set default email if not already set!
  if [[ -z $(git config user.email) ]]; then
    GIT_AUTHOR_EMAIL_SET_BY_TEST=true
    git config --global user.email "${GIT_AUTHOR_EMAIL}"
  fi

  # Initialize FOLDER as git repository
  git init 1>/dev/null
}

function tearDown() {
  if [[ -n "${OLD_GIT_AUTHOR_NAME}" ]]; then
    GIT_AUTHOR_NAME=$OLD_GIT_AUTHOR
    unset OLD_GIT_AUTHOR_NAME
  else
    unset GIT_AUTHOR_NAME
  fi

  if [[ -n "${OLD_GIT_AUTHOR_EMAIL}" ]]; then
    GIT_AUTHOR_EMAIL=$OLD_GIT_AUTHOR_EMAIL
    unset OLD_GIT_AUTHOR_EMAIL
  else
    unset GIT_AUTHOR_EMAIL
  fi

  if [[ "${GIT_AUTHOR_NAME_SET_BY_TEST}" == "true" ]]; then
    git config --global --unset user.name
  fi
  if [[ "${GIT_AUTHOR_EMAIL_SET_BY_TEST}" == "true" ]]; then
    git config --global --unset user.email
  fi

  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
  unset FOLDER
}

function testColorOverridingForCleanStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_CLEAN_FOREGROUND='cyan'
  local P9K_VCS_CLEAN_BACKGROUND='white'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{015} %F{006} master %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingForModifiedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_MODIFIED_FOREGROUND='red'
  local P9K_VCS_MODIFIED_BACKGROUND='yellow'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch testfile
  git add testfile
  git commit -m "test" 1>/dev/null
  echo "test" > testfile

  assertEquals "%K{003} %F{001} master ● %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingForUntrackedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNTRACKED_FOREGROUND='cyan'
  local P9K_VCS_UNTRACKED_BACKGROUND='yellow'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch testfile

  assertEquals "%K{003} %F{006}? %f%F{006} master ? %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testGitIconWorks() {
  local P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_ICON='Git-icon'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{002} %F{000}Git-icon %f%F{000} master %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testGitlabIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_GITLAB_ICON='GL-icon'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Add a GitLab project as remote origin. This is
  # sufficient to show the GitLab-specific icon.
  git remote add origin https://gitlab.com/dritter/gitlab-test-project.git

  assertEquals "%K{002} %F{000}GL-icon %f%F{000} master %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testBitbucketIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_BITBUCKET_ICON='BB-icon'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Add a BitBucket project as remote origin. This is
  # sufficient to show the BitBucket-specific icon.
  git remote add origin https://dritter@bitbucket.org/dritter/dr-test.git

  assertEquals "%K{002} %F{000}BB-icon %f%F{000} master %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testGitHubIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_GITHUB_ICON='GH-icon'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Add a GitHub project as remote origin. This is
  # sufficient to show the GitHub-specific icon.
  git remote add origin https://github.com/dritter/test.git

  assertEquals "%K{002} %F{000}GH-icon %f%F{000} master %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testUntrackedFilesIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Create untracked file
  touch "i-am-untracked.txt"

  assertEquals "%K{002} %F{000}? %f%F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testStagedFilesIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_STAGED_ICON='+'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Create staged file
  touch "i-am-added.txt"
  git add i-am-added.txt &>/dev/null
  git commit -m "initial commit" &>/dev/null
  echo "xx" >> i-am-added.txt
  git add i-am-added.txt &>/dev/null

  assertEquals "%K{003} %F{000} master + %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testUnstagedFilesIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNSTAGED_ICON='M'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Create unstaged (modified, but not added to index) file
  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" 1>/dev/null
  echo "xx" > i-am-modified.txt

  assertEquals "%K{003} %F{000} master M %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testStashIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_STASH_ICON='S'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  # Create modified file
  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" 1>/dev/null
  echo "xx" > i-am-modified.txt
  git stash 1>/dev/null

  assertEquals "%K{002} %F{000} master S1 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testTagIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_TAG_ICON='T'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null
  git tag "v0.0.1"

  assertEquals "%K{002} %F{000} master Tv0.0.1 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testTagIconInDetachedHeadState() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_TAG_ICON='T'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" &>/dev/null
  git tag "v0.0.1"
  touch "file2.txt"
  git add file2.txt
  git commit -m "Add File2" &>/dev/null
  git checkout v0.0.1 &>/dev/null
  local hash=$(git rev-list -n 1 --abbrev-commit --abbrev=8 HEAD)

  assertEquals "%K{002} %F{000} ${hash} Tv0.0.1 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testActionHintWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null
  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  cd ../vcs-test2
  echo "yy" >> i-am-modified.txt
  git commit -a -m "Provoke conflict" &>/dev/null
  git pull &>/dev/null

  assertEquals "%K{003} %F{000} master %F{001}| merge%f %k%F{003}%f " "$(__p9k_build_left_prompt)"
}

function testIncomingHintWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_INCOMING_CHANGES_ICON='I'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null
  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  cd ../vcs-test2
  git fetch &>/dev/null

  assertEquals "%K{002} %F{000} master I1 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testOutgoingHintWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_OUTGOING_CHANGES_ICON='O'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null

  cd ../vcs-test2

  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  assertEquals "%K{002} %F{000} master O1 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testShorteningCommitHashWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHOW_CHANGESET=true
  local P9K_VCS_CHANGESET_HASH_LENGTH='4'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null
  local hash=$(git rev-list -n 1 --abbrev-commit --abbrev=3 HEAD)

  # This test needs to call __p9k_vcs_init, where
  # the changeset is truncated.
  __p9k_vcs_init
  assertEquals "%K{002} %F{000}${hash}  master %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testShorteningCommitHashIsNotShownIfShowChangesetIsFalse() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHOW_CHANGESET=false
  local P9K_VCS_CHANGESET_HASH_LENGTH='4'
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null

  # This test needs to call __p9k_vcs_init, where
  # the changeset is truncated.
  __p9k_vcs_init
  assertEquals "%K{002} %F{000} master %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testBranchNameTruncatingShortenLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=6
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{002} %F{000}? %f%F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_SHORTEN_LENGTH=3
  assertEquals "%K{002} %F{000}? %f%F{000} mas… ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingMinLength() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=6
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{002} %F{000}? %f%F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_SHORTEN_MIN_LENGTH=7

  assertEquals "%K{002} %F{000}? %f%F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testBranchNameTruncatingShortenStrategy() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHORTEN_LENGTH=3
  local P9K_VCS_SHORTEN_MIN_LENGTH=3
  local P9K_VCS_SHORTEN_STRATEGY="truncate_from_right"
  source ${P9K_HOME}/powerlevel9k.zsh-theme

  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p $FOLDER
  cd $FOLDER
  git init 1>/dev/null
  touch testfile

  assertEquals "%K{002} %F{000}? %f%F{000} mas… ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_SHORTEN_STRATEGY="truncate_middle"

  assertEquals "%K{002} %F{000}? %f%F{000} mas…ter ? %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
  rm -fr /tmp/powerlevel9k-test
}

function testRemoteBranchNameIdenticalToTag() {
  # This tests the fix from #941
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)

  echo "test" > test.txt
  git add test.txt 1>/dev/null
  git commit -m "Initial commit" 1>/dev/null

  # Prepare a tag named "test"
  git tag test 1>/dev/null

  # Prepare branch named "test"
  git checkout -b test 1>/dev/null 2>&1

  # Clone Repo
  git clone . ../vcs-test2 1>/dev/null 2>&1
  cd ../vcs-test2

  git checkout test 1>/dev/null 2>&1

  assertEquals "%K{002} %F{000} test test %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testAlwaysShowRemoteBranch() {
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_ALWAYS_SHOW_REMOTE_BRANCH='true'
  local P9K_VCS_HIDE_TAGS='true'

  echo "test" > test.txt
  git add . 1>/dev/null
  git commit -m "Initial Commit" 1>/dev/null

  git clone . ../vcs-test2 1>/dev/null 2>&1
  cd ../vcs-test2

  assertEquals "%K{002} %F{000} master→origin/master %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_VCS_GIT_ALWAYS_SHOW_REMOTE_BRANCH='false'
  assertEquals "%K{002} %F{000} master %k%F{002}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testGitDirClobber() {
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_ALWAYS_SHOW_REMOTE_BRANCH='true'
  local P9K_VCS_HIDE_TAGS='true'

  echo "xxx" > xxx.txt
  git add . 1>/dev/null
  git commit -m "Initial Commit" 1>/dev/null

  cd ..

  git clone --bare vcs-test test-dotfiles 1>/dev/null 2>&1

  # Create completely independent git repo in a sub directory.
  mkdir vcs-test2
  cd vcs-test2
  git init 1>/dev/null
  echo "yyy" > yyy.txt
  git add . 1>/dev/null
  git commit -m "Initial Commit" 1>/dev/null

  cd ..

  export GIT_DIR="${PWD}/test-dotfiles" GIT_WORK_TREE="${PWD}"

  # CD into the second dir that is below the git work tree,
  # so for git this is a repo inside another repo.
  cd vcs-test2

  assertEquals "%K{001} %F{000}✘  /tmp/powerlevel9k-test/test-dotfiles  master ✚ ? %k%F{001}%f " "$(__p9k_build_left_prompt)"

  cd -
  unset GIT_DIR
  unset GIT_WORK_TREE
}

function testDetectingUntrackedFilesInSubmodulesWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHOW_SUBMODULE_DIRTY="true"
  unset P9K_VCS_UNTRACKED_BACKGROUND

  mkdir ../submodule
  cd ../submodule
  git init 1>/dev/null
  touch "i-am-tracked.txt"
  git add . 1>/dev/null && git commit -m "Initial Commit" 1>/dev/null
  # Create untracked file
  touch "i-am-untracked.txt"

  local submodulePath="${PWD}"

  cd -
  git submodule add "${submodulePath}" 2>/dev/null
  git commit -m "Add submodule" 1>/dev/null

  source ${P9K_HOME}/powerlevel9k.zsh-theme

  assertEquals "%K{002} %F{000}? %f%F{000} master ? %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2
