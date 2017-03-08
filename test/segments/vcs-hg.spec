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
  # Create default folder and hg init it.
  FOLDER=/tmp/powerlevel9k-test/vcs-test
  mkdir -p "${FOLDER}"
  cd $FOLDER

  export HGUSER="Test bot <bot@example.com>"

  hg init 1>/dev/null
}

function tearDown() {
  # Go back to powerlevel9k folder
  cd "${P9K_HOME}"
  # Remove eventually created test-specific folder
  rm -fr "${FOLDER}" &>/dev/null
  # At least remove test folder completely
  rm -fr /tmp/powerlevel9k-test &>/dev/null
  unset FOLDER
  unset HGUSER
  p9k_clear_cache
}

function testColorOverridingForCleanStateWorks() {
  POWERLEVEL9K_VCS_CLEAN_FOREGROUND='cyan'
  POWERLEVEL9K_VCS_CLEAN_BACKGROUND='white'

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{white} %F{cyan}default %k%F{white}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_CLEAN_FOREGROUND
  unset POWERLEVEL9K_VCS_CLEAN_BACKGROUND
}

function testColorOverridingForModifiedStateWorks() {
  POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='red'
  POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'

  touch testfile
  hg add testfile
  hg commit -m "test" 1>/dev/null
  echo "test" > testfile

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache 0

  assertEquals "%K{yellow} %F{red}default ● %k%F{yellow}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_MODIFIED_FOREGROUND
  unset POWERLEVEL9K_VCS_MODIFIED_BACKGROUND
}

# There is no staging area in mercurial, therefore there are no "untracked"
# files.. In case there are added files, we show the VCS segment with a
# yellow background.
# This may be improved in future versions, to be a bit more consistent with
# the git part.
function testAddedFilesIconWorks() {
  touch "myfile.txt"
  hg add myfile.txt

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black}default ● %k%F{yellow}%f " "${PROMPT}"
}

# We don't support tagging in mercurial right now..
# function testTagIconWorks() {
#   POWERLEVEL9K_VCS_TAG_ICON='T'

#   touch "file.txt"
#   hg add file.txt
#   hg commit -m "Add File" 1>/dev/null
#   hg tag "v0.0.1"

#   prompt_vcs "left" "1" "false"
#   p9k_build_prompt_from_cache

#   assertEquals "%K{green} %F{black} default Tv0.0.1 %k%F{green}%f " "${PROMPT}"

#   unset POWERLEVEL9K_VCS_TAG_ICON
# }

# function testTagIconInDetachedHeadState() {
#   POWERLEVEL9K_VCS_TAG_ICON='T'

#   touch "file.txt"
#   hg add file.txt
#   hg commit -m "Add File" &>/dev/null
#   hg tag "v0.0.1"
#   touch "file2.txt"
#   hg add file2.txt
#   hg commit -m "Add File2" &>/dev/null
#   hg checkout v0.0.1 &>/dev/null
#   local hash=$(hg id)

#   prompt_vcs "left" "1" "false"
#   p9k_build_prompt_from_cache

#   assertEquals "%K{green} %F{black} ${hash} Tv0.0.1 %k%F{green}%f " "${PROMPT}"

#   unset POWERLEVEL9K_VCS_TAG_ICON
# }

function testActionHintWorks() {
  touch "i-am-modified.txt"
  hg add i-am-modified.txt
  hg commit -m "Add File" &>/dev/null

  hg clone . ../vcs-test2 &>/dev/null
  echo "xx" >> i-am-modified.txt
  hg commit -m "Modified file" &>/dev/null

  cd ../vcs-test2
  echo "yy" >> i-am-modified.txt
  hg commit -m "Provoke conflict" &>/dev/null
  hg pull 1>/dev/null
  hg merge --tool internal:merge 1>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{yellow} %F{black}default %F{red}| merging%f %k%F{yellow}%f " "${PROMPT}"
}

function testShorteningCommitHashWorks() {
  POWERLEVEL9K_SHOW_CHANGESET=true
  POWERLEVEL9K_CHANGESET_HASH_LENGTH='4'

  touch "file.txt"
  hg add file.txt
  hg commit -m "Add File" 1>/dev/null
  local hash=$(hg id | head -c ${POWERLEVEL9K_CHANGESET_HASH_LENGTH})

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}${hash} default %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHOW_CHANGESET
  unset POWERLEVEL9K_CHANGESET_HASH_LENGTH
}

function testShorteningCommitHashIsNotShownIfShowChangesetIsFalse() {
  POWERLEVEL9K_SHOW_CHANGESET=false
  POWERLEVEL9K_CHANGESET_HASH_LENGTH='4'

  touch "file.txt"
  hg add file.txt
  hg commit -m "Add File" 1>/dev/null

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}default %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_SHOW_CHANGESET
  unset POWERLEVEL9K_CHANGESET_HASH_LENGTH
}

function testMercurialIconWorks() {
  POWERLEVEL9K_VCS_HG_ICON='HG-Icon'

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black%}HG-Icon%f %F{black}default %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_HG_ICON
}

function testBookmarkIconWorks() {
  POWERLEVEL9K_VCS_BOOKMARK_ICON='B'
  hg bookmark "initial"

  prompt_vcs "left" "1" "false"
  p9k_build_prompt_from_cache

  assertEquals "%K{green} %F{black}default Binitial %k%F{green}%f " "${PROMPT}"

  unset POWERLEVEL9K_VCS_BOOKMARK_ICON
}

source shunit2/source/2.1/src/shunit2