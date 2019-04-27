#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function oneTimeSetUp() {
  export TERM="xterm-256color"

  OLD_DIR="${PWD}"

  TEST_BASE_FOLDER="/tmp/powerlevel9k-test"
  NODE_VERSION_TEST_FOLDER="${TEST_BASE_FOLDER}/node_version-test"
  
  OLDPATH="${PATH}"
  PATH="${NODE_VERSION_TEST_FOLDER}:${PATH}"
  
  P9K_CUSTOM_WORLD='echo world'

  node() {
    echo "v1.2.3"
  }
}

function setUp() {
  # Load Powerlevel9k
  source "${OLD_DIR}/powerlevel9k.zsh-theme"
  source "${OLD_DIR}/segments/node_version/node_version.p9k"

  P9K_LEFT_PROMPT_ELEMENTS=(node_version)
  P9K_RIGHT_PROMPT_ELEMENTS=()

  mkdir -p "${NODE_VERSION_TEST_FOLDER}"
  cd "${NODE_VERSION_TEST_FOLDER}"
}

function tearDown() {
  cd "${OLD_DIR}"
  rm -rf "${NODE_VERSION_TEST_FOLDER}"
}

function oneTimeTearDown() {
  PATH="${OLDPATH}"

  cd "${OLD_DIR}"
  rm -rf "${TEST_BASE_FOLDER}"
}

function testNodeVersionSegmentWorks() {
  assertEquals "%K{002} %F{015}⬢ %F{015}1.2.3 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testNodeVersionSegmentPrintsNothingWithoutNode() {
  P9K_LEFT_PROMPT_ELEMENTS+=(custom_world)
  
  alias node="nonode 2>/dev/null"

  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"

  unalias node
}

function testNodeVersionSegmentProjectOnlyPrintsNothingOutsideProjectDirectory() {
  P9K_LEFT_PROMPT_ELEMENTS+=(custom_world)

  P9K_NODE_VERSION_PROJECT_ONLY=true
  
  assertEquals "%K{015} %F{000}world %k%F{015}%f " "$(__p9k_build_left_prompt)"
}

function testNodeVersionSegmentProjectOnlyWorksInsideProjectDirectory() {
  P9K_NODE_VERSION_PROJECT_ONLY=true

  touch ./package.json

  assertEquals "%K{002} %F{015}⬢ %F{015}1.2.3 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

function testNodeVersionSegmentProjectOnlyWorksInsideProjectChildDirectory() {
  P9K_NODE_VERSION_PROJECT_ONLY=true

  touch ./package.json
  mkdir test-child
  cd test-child

  assertEquals "%K{002} %F{015}⬢ %F{015}1.2.3 %k%F{002}%f " "$(__p9k_build_left_prompt)"
}

source shunit2/shunit2
