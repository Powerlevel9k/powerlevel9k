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

  # Load Powerlevel9k
  source ${P9K_HOME}/powerlevel9k.zsh-theme
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
  source ${P9K_HOME}/segments/vcs.p9k

  assertEquals "%K{white} %F{cyan} master %k%F{white}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingForModifiedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_MODIFIED_FOREGROUND='red'
  local P9K_VCS_MODIFIED_BACKGROUND='yellow'
  source ${P9K_HOME}/segments/vcs.p9k

  touch testfile
  git add testfile
  git commit -m "test" 1>/dev/null
  echo "test" > testfile

  assertEquals "%K{yellow} %F{red} master ● %k%F{yellow}%f " "$(__p9k_build_left_prompt)"
}

function testColorOverridingForUntrackedStateWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNTRACKED_FOREGROUND='cyan'
  local P9K_VCS_UNTRACKED_BACKGROUND='yellow'
  source ${P9K_HOME}/segments/vcs.p9k

  touch testfile

  assertEquals "%K{yellow} %F{cyan} master ? %k%F{yellow}%f " "$(__p9k_build_left_prompt)"
}

function testGitIconWorks() {
  local P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_ICON='*Git-Icon'
  source ${P9K_HOME}/segments/vcs.p9k

  assertEquals "%K{green} %F{black}*Git-Icon %f%F{black} master %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testGitlabIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_GITLAB_ICON='*GL-Icon'
  source ${P9K_HOME}/segments/vcs.p9k

  # Add a GitLab project as remote origin. This is
  # sufficient to show the GitLab-specific icon.
  git remote add origin https://gitlab.com/dritter/gitlab-test-project.git

  assertEquals "%K{green} %F{black}*GL-Icon %f%F{black} master %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testBitbucketIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_BITBUCKET_ICON='*BB-Icon'
  source ${P9K_HOME}/segments/vcs.p9k

  # Add a BitBucket project as remote origin. This is
  # sufficient to show the BitBucket-specific icon.
  git remote add origin https://dritter@bitbucket.org/dritter/dr-test.git

  assertEquals "%K{green} %F{black}*BB-Icon %f%F{black} master %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testGitHubIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_GIT_GITHUB_ICON='*GH-Icon'
  source ${P9K_HOME}/segments/vcs.p9k

  # Add a GitHub project as remote origin. This is
  # sufficient to show the GitHub-specific icon.
  git remote add origin https://github.com/dritter/test.git

  assertEquals "%K{green} %F{black}*GH-Icon %f%F{black} master %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testUntrackedFilesIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNTRACKED_ICON='?'
  source ${P9K_HOME}/segments/vcs.p9k

  # Create untracked file
  touch "i-am-untracked.txt"

  assertEquals "%K{green} %F{black} master ? %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testStagedFilesIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_STAGED_ICON='+'
  source ${P9K_HOME}/segments/vcs.p9k

  # Create staged file
  touch "i-am-added.txt"
  git add i-am-added.txt &>/dev/null
  git commit -m "initial commit" &>/dev/null
  echo "xx" >> i-am-added.txt
  git add i-am-added.txt &>/dev/null

  assertEquals "%K{yellow} %F{black} master + %k%F{yellow}%f " "$(__p9k_build_left_prompt)"
}

function testUnstagedFilesIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_UNSTAGED_ICON='*M'
  source ${P9K_HOME}/segments/vcs.p9k

  # Create unstaged (modified, but not added to index) file
  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" 1>/dev/null
  echo "xx" > i-am-modified.txt

  assertEquals "%K{yellow} %F{black} master *M %k%F{yellow}%f " "$(__p9k_build_left_prompt)"
}

function testStashIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_STASH_ICON='*S'
  source ${P9K_HOME}/segments/vcs.p9k

  # Create modified file
  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" 1>/dev/null
  echo "xx" > i-am-modified.txt
  git stash 1>/dev/null

  assertEquals "%K{green} %F{black} master *S1 %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testTagIconWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_TAG_ICON='*T'
  source ${P9K_HOME}/segments/vcs.p9k

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null
  git tag "v0.0.1"

  assertEquals "%K{green} %F{black} master *Tv0.0.1 %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testTagIconInDetachedHeadState() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_TAG_ICON='*T'
  source ${P9K_HOME}/segments/vcs.p9k

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" &>/dev/null
  git tag "v0.0.1"
  touch "file2.txt"
  git add file2.txt
  git commit -m "Add File2" &>/dev/null
  git checkout v0.0.1 &>/dev/null
  local hash=$(git rev-list -n 1 --abbrev-commit --abbrev=8 HEAD)

  assertEquals "%K{green} %F{black} ${hash} *Tv0.0.1 %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testActionHintWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  source ${P9K_HOME}/segments/vcs.p9k

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

  assertEquals "%K{yellow} %F{black} master %F{red}| merge%f %k%F{yellow}%f " "$(__p9k_build_left_prompt)"
}

function testIncomingHintWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_INCOMING_CHANGES_ICON='*I'
  source ${P9K_HOME}/segments/vcs.p9k

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null
  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  cd ../vcs-test2
  git fetch &>/dev/null

  assertEquals "%K{green} %F{black} master *I1 %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testOutgoingHintWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_OUTGOING_CHANGES_ICON='*O'
  source ${P9K_HOME}/segments/vcs.p9k

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null

  cd ../vcs-test2

  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  assertEquals "%K{green} %F{black} master *O1 %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testShorteningCommitHashWorks() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHOW_CHANGESET=true
  local P9K_VCS_CHANGESET_HASH_LENGTH='4'
  source ${P9K_HOME}/segments/vcs.p9k

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null
  local hash=$(git rev-list -n 1 --abbrev-commit --abbrev=3 HEAD)

  # This test needs to call __p9k_vcs_init, where
  # the changeset is truncated.
  __p9k_vcs_init
  assertEquals "%K{green} %F{black}${hash}  master %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

function testShorteningCommitHashIsNotShownIfShowChangesetIsFalse() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(vcs)
  local P9K_VCS_SHOW_CHANGESET=false
  local P9K_VCS_CHANGESET_HASH_LENGTH='4'
  source ${P9K_HOME}/segments/vcs.p9k

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null

  # This test needs to call __p9k_vcs_init, where
  # the changeset is truncated.
  __p9k_vcs_init
  assertEquals "%K{green} %F{black} master %k%F{green}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/source/2.1/src/shunit2
