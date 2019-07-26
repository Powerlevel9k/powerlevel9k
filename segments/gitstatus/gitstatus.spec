#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  P9K_HOME="${PWD}"

  source powerlevel9k.zsh-theme
  
  ### Test specific
  # Create default folder and git init it.
  FOLDER=/tmp/powerlevel9k-test/gitstatus-test
  mkdir -p "${FOLDER}"
  cd $FOLDER
  mkdir $FOLDER/bin
  
  cat > $FOLDER/bin/gitstatus.plugin.zsh <<EOF
#!/usr/bin/env zsh
  
function gitstatus_start() {}
function gitstatus_query() {}
EOF
  P9K_GITSTATUS_DIR="${FOLDER}/bin"
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test
  unset FOLDER
  unset P9K_HOME
}

function testGitstatusRemoteBranchIsDisplayedIfLocalAndRemoteDiffer() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(gitstatus)
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  
  local VCS_STATUS_RESULT="ok-sync"
  local VCS_STATUS_LOCAL_BRANCH='master'
  local VCS_STATUS_REMOTE_BRANCH='remotes/somebody/master'

  assertEquals "%K{002} %F{000}\${:-\" master →remotes/somebody/master\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testGitstatusRemoteBranchIsHiddenIfLocalAndRemoteAreEqual() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(gitstatus)
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  
  local VCS_STATUS_RESULT="ok-sync"
  local VCS_STATUS_LOCAL_BRANCH='master'
  local VCS_STATUS_REMOTE_BRANCH='master'

  assertEquals "%K{002} %F{000}\${:-\" master\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testGitstatusActionformat() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(gitstatus)
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  
  local VCS_STATUS_RESULT="ok-sync"
  local VCS_STATUS_LOCAL_BRANCH='%E%K{blue}'
  local VCS_STATUS_ACTION="merge"

  assertEquals "%K{002} %F{000}\${:-\" %%E%%K{blue} %F{001}| merge%f%F{}\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testNoPercentEscapesLeak() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(gitstatus)
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  
  local VCS_STATUS_RESULT="ok-sync"
  local VCS_STATUS_LOCAL_BRANCH='%E%K{red}'

  assertEquals "%K{002} %F{000}\${:-\" %%E%%K{red}\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testGitstatusVisualIdentifier() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(gitstatus)

  local VCS_STATUS_RESULT="ok-sync"
  local VCS_STATUS_LOCAL_BRANCH="master"

  local P9K_GITSTATUS_GIT_ICON='Git-icon'
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  local VCS_STATUS_REMOTE_URL="https://some.unknown/url"
  assertEquals "%K{002} %F{000}Git-icon %F{000}\${:-\" master\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_GITSTATUS_BITBUCKET_ICON='BB-icon'
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  local VCS_STATUS_REMOTE_URL="https://dritter@bitbucket.org/dritter/dr-test.git"
  assertEquals "%K{002} %F{000}BB-icon %F{000}\${:-\" master\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_GITSTATUS_GITLAB_ICON='GL-icon'
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  local VCS_STATUS_REMOTE_URL="https://gitlab.com/dritter/gitlab-test-project.git"
  assertEquals "%K{002} %F{000}GL-icon %F{000}\${:-\" master\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"

  local P9K_GITSTATUS_GITHUB_ICON='GH-icon'
  source "${P9K_HOME}/segments/gitstatus/gitstatus.p9k"
  local VCS_STATUS_REMOTE_URL="https://github.com/dritter/test.git"
  assertEquals "%K{002} %F{000}GH-icon %F{000}\${:-\" master\"} %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2