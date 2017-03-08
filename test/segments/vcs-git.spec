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
  p9k_clear_cache
}

function testColorOverridingForCleanStateWorks() {
  POWERLEVEL9K_VCS_CLEAN_FOREGROUND='cyan'
  POWERLEVEL9K_VCS_CLEAN_BACKGROUND='white'

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{white} %F{cyan}master %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  unset POWERLEVEL9K_VCS_CLEAN_BACKGROUND
}

function testColorOverridingForModifiedStateWorks() {
  POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='red'
  POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'

  touch testfile
  git add testfile
  git commit -m "test" 1>/dev/null
  echo "test" > testfile

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{yellow} %F{red}master ● %k%F{yellow}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  unset POWERLEVEL9K_VCS_MODIFIED_BACKGROUND
}

function testColorOverridingForUntrackedStateWorks() {
  POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='cyan'
  POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'

  touch testfile

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{yellow} %F{cyan}master ? %k%F{yellow}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND
  unset POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND
}

function testGitIconWorks() {
  POWERLEVEL9K_VCS_GIT_ICON='Git-Icon'

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{green} %F{black%}Git-Icon%f %F{black}master %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_GIT_ICON
}

function testGitlabIconWorks() {
  POWERLEVEL9K_VCS_GIT_GITLAB_ICON='GL-Icon'

  # Add a GitLab project as remote origin. This is
  # sufficient to show the GitLab-specific icon.
  git remote add origin https://gitlab.com/dritter/gitlab-test-project.git

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black%}GL-Icon%f %F{black}master %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_GIT_GITLAB_ICON
}

function testBitbucketIconWorks() {
  POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON='BB-Icon'

  # Add a BitBucket project as remote origin. This is
  # sufficient to show the BitBucket-specific icon.
  git remote add origin https://dritter@bitbucket.org/dritter/dr-test.git

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black%}BB-Icon%f %F{black}master %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_GIT_BITBUCKET_ICON
}

function testGitHubIconWorks() {
  POWERLEVEL9K_VCS_GIT_GITHUB_ICON='GH-Icon'

  # Add a GitHub project as remote origin. This is
  # sufficient to show the GitHub-specific icon.
  git remote add origin https://github.com/dritter/test.git

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black%}GH-Icon%f %F{black}master %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_GIT_GITHUB_ICON
}

function testUntrackedFilesIconWorks() {
  POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Create untracked file
  touch "i-am-untracked.txt"

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}master ? %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_UNTRACKED_ICON
}

function testStagedFilesIconWorks() {
  POWERLEVEL9K_VCS_STAGED_ICON='+'

  # Create staged file
  touch "i-am-added.txt"
  git add i-am-added.txt &>/dev/null
  git commit -m "initial commit" &>/dev/null
  echo "xx" >> i-am-added.txt
  git add i-am-added.txt &>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black}master + %k%F{yellow}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_STAGED_ICON
}

function testUnstagedFilesIconWorks() {
  POWERLEVEL9K_VCS_UNSTAGED_ICON='M'

  # Create unstaged (modified, but not added to index) file
  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" 1>/dev/null
  echo "xx" > i-am-modified.txt

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black}master M %k%F{yellow}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_UNSTAGED_ICON
}

function testStashIconWorks() {
  POWERLEVEL9K_VCS_STASH_ICON='S'

  # Create modified file
  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" 1>/dev/null
  echo "xx" > i-am-modified.txt
  git stash 1>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}master S1 %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_STASH_ICON
}

function testTagIconWorks() {
  POWERLEVEL9K_VCS_TAG_ICON='T'

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null
  git tag "v0.0.1"

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}master Tv0.0.1 %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_TAG_ICON
}

function testTagIconInDetachedHeadState() {
  POWERLEVEL9K_VCS_TAG_ICON='T'

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" &>/dev/null
  git tag "v0.0.1"
  touch "file2.txt"
  git add file2.txt
  git commit -m "Add File2" &>/dev/null
  git checkout v0.0.1 &>/dev/null
  local hash=$(git rev-list -n 1 --abbrev-commit --abbrev=8 HEAD)

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}${hash} Tv0.0.1 %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_TAG_ICON
}

function testActionHintWorks() {
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

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black}master %F{red}| merge%f %k%F{yellow}%f " "${PROMPT}"
}

function testIncomingHintWorks() {
  POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='I'

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null
  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  cd ../vcs-test2
  git fetch &>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}master I1 %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON
}

function testOutgoingHintWorks() {
  POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='o'

  touch "i-am-modified.txt"
  git add i-am-modified.txt
  git commit -m "Add File" &>/dev/null

  git clone . ../vcs-test2 &>/dev/null

  cd ../vcs-test2

  echo "xx" >> i-am-modified.txt
  git commit -a -m "Modified file" &>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}master o1 %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON
}

function testShorteningCommitHashWorks() {
  POWERLEVEL9K_SHOW_CHANGESET=true
  POWERLEVEL9K_CHANGESET_HASH_LENGTH='4'

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null
  local hash=$(git rev-list -n 1 --abbrev-commit --abbrev=3 HEAD)

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}${hash} master %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHOW_CHANGESET
  unset POWERLEVEL9K_CHANGESET_HASH_LENGTH
}

function testShorteningCommitHashIsNotShownIfShowChangesetIsFalse() {
  POWERLEVEL9K_SHOW_CHANGESET=false
  POWERLEVEL9K_CHANGESET_HASH_LENGTH='4'

  touch "file.txt"
  git add file.txt
  git commit -m "Add File" 1>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}master %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHOW_CHANGESET
  unset POWERLEVEL9K_CHANGESET_HASH_LENGTH
}

source shunit2/source/2.1/src/shunit2
