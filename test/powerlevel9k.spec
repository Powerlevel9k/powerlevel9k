#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
  source functions/*
  source segments/dir/dir.p9k

  # Unset mode, so that user settings
  # do not interfere with tests
}

function testUsingUnsetVariables() {
  setopt local_options
  set -u
  __p9k_prepare_prompts
}

function testJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir dir::joined)
  cd /tmp

  assertEquals "%K{004} %F{000}/tmp %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testTransitiveJoinedSegments() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir root_indicator::joined dir::joined)
  source segments/root_indicator/root_indicator.p9k
  cd /tmp

  assertEquals "%K{004} %F{000}/tmp %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testJoiningWithConditionalSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir background_jobs dir::joined)
  source segments/background_jobs/background_jobs.p9k
  local jobs_running=0
  local jobs_suspended=0

  cd /tmp

  assertEquals "%K{004} %F{000}/tmp  %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testTaggingSegments() {
  local -a configured_segments=(s1 s2::a s3::b s4::a::b s5::b::a s6)
  local -a tagged_segments=(s2 s4 s5)

  for segment in ${configured_segments}; do
    local -a segment_meta=("${(s.::.)segment}")
    local segment_name="${segment_meta[1]}"
    if p9k::segment_is_tagged_as "a" "${segment_meta}"; then
      [[ -z "${tagged_segments[(r)${segment_name}]}" ]] && \
          fail "Segment ${segment_name} should be recognised to be tagged."
    fi
  done
}

function testDynamicColoringOfSegmentsWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_BACKGROUND='red'
  source segments/dir/dir.p9k

  cd /tmp

  assertEquals "%K{001} %F{000}/tmp %k%F{001}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testDynamicColoringOfVisualIdentifiersWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON_COLOR='green'
  local P9K_DIR_DEFAULT_ICON="icon-here"
  source segments/dir/dir.p9k

  cd /tmp

  assertEquals "%K{004} %F{002}icon-here %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testColoringOfVisualIdentifiersDoesNotOverwriteColoringOfSegment() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON_COLOR='green'
  local P9K_DIR_DEFAULT_FOREGROUND='red'
  local P9K_DIR_DEFAULT_BACKGROUND='yellow'
  local P9K_DIR_DEFAULT_ICON="icon-here"
  source segments/dir/dir.p9k

  # Re-Source the icons, as the P9K_MODE is directly
  # evaluated there.
  source functions/icons.zsh

  cd /tmp

  assertEquals "%K{003} %F{002}icon-here %F{001}/tmp %k%F{003}%f " "$(__p9k_build_left_prompt)"

  cd -
}

function testOverwritingIconsWork() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(dir)
  local P9K_DIR_DEFAULT_ICON='icon-here'
  source segments/dir/dir.p9k
  #local testFolder=$(mktemp -d -p p9k)
  # Move testFolder under home folder
  #mv testFolder ~
  # Go into testFolder
  #cd ~/$testFolder

  cd /tmp
  assertEquals "%K{004} %F{000}icon-here %F{000}/tmp %k%F{004}%f " "$(__p9k_build_left_prompt)"

  cd -
  # rm -fr ~/$testFolder
}

function testNewlineOnRpromptCanBeDisabled() {
  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_RPROMPT_ON_NEWLINE=false
  local P9K_CUSTOM_WORLD='echo world'
  local P9K_CUSTOM_RWORLD='echo rworld'
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(world::custom)
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(rworld::custom)

  __p9k_prepare_prompts

  local nl=$'\n'
  #               ╭─[39m[0m[49m[107m [30mworld [49m[97m[39m  ╰─ [1A[39m[0m[49m[97m[107m[30m rworld [00m[1B
  local expected="╭─[39m[0m[49m[107m [30mworld [49m[97m[39m ${nl}╰─ [1A[39m[0m[49m[97m[107m[30m rworld [00m[1B"
  local _real="$(print -P ${PROMPT}${RPROMPT})"

  # use this to debug output with special escape sequences
  # new lines for escape codes that move output one line above
  # set -vx;
  # echo "\n__1__\n"
  # echo "\n__${expected}__\n"
  # echo "\n__2__\n"
  # echo "\n__${_real}__\n"
  # echo "\n__3__\n"
  # set +vx;

  assertEquals "$expected" "$_real"

}

source shunit2/shunit2
