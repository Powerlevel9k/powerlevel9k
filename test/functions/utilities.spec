#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  # to ensure autoloading works
  p9kDirectory=${PWD//test\/functions/}
  # Load Powerlevel9k
  source functions/utilities.zsh
  source functions/icons.zsh
}

function testDefinedFindsDefinedVariable() {
  my_var='X'

  assertTrue "defined 'my_var'"
  unset my_var
}

function testDefinedDoesNotFindUndefinedVariable() {
  assertFalse "defined 'my_var'"
}

function testSetDefaultSetsVariable() {
  setDefault 'my_var' 'x'

  assertEquals 'x' "$my_var"
  unset my_var
}

function testPrintSizeHumanReadableWithBigNumber() {
  # Interesting: Currently we can't support numbers bigger than that.
  assertEquals '0.87E' "$(printSizeHumanReadable 1000000000000000000)"
}

function testPrintSizeHumanReadableWithExabytesAsBase() {
  assertEquals '9.77Z' "$(printSizeHumanReadable 10000 'E')"
}

function testGetRelevantItem() {
  typeset -a list
  list=(a b c)
  local callback='[[ "$item" == "b" ]] && echo "found"'

  local result=$(getRelevantItem "$list" "$callback")
  assertEquals 'found' "$result"

  unset list
}

function testGetRelevantItemDoesNotReturnNotFoundItems() {
  typeset -a list
  list=(a b c)
  local callback='[[ "$item" == "d" ]] && echo "found"'

  local result=$(getRelevantItem "$list" "$callback")
  assertEquals '' ''

  unset list
}

function testSegmentShouldBeJoinedIfDirectPredecessingSegmentIsJoined() {
  typeset -a segments
  segments=(a b_joined c_joined)
  # Look at the third segment
  local current_index=3
  local last_element_index=2

  local joined
  segmentShouldBeJoined $current_index $last_element_index "$segments" && joined=true || joined=false
  assertTrue "$joined"

  unset segments
}

function testSegmentShouldBeJoinedIfPredecessingSegmentIsJoinedTransitivley() {
  typeset -a segments
  segments=(a b_joined c_joined)
  # Look at the third segment
  local current_index=3
  # The last printed segment was the first one,
  # the second segmend was conditional.
  local last_element_index=1

  local joined
  segmentShouldBeJoined $current_index $last_element_index "$segments" && joined=true || joined=false
  assertTrue "$joined"

  unset segments
}

function testSegmentShouldNotBeJoinedIfPredecessingSegmentIsNotJoinedButConditional() {
  typeset -a segments
  segments=(a b_joined c d_joined)
  # Look at the fourth segment
  local current_index=4
  # The last printed segment was the first one,
  # the second segmend was conditional.
  local last_element_index=1

  local joined
  segmentShouldBeJoined $current_index $last_element_index "$segments" && joined=true || joined=false
  assertFalse "$joined"

  unset segments
}

function testUpsearchWithFiles() {
  local OLDPWD="${PWD}"
  # On Mac /tmp is a symlink to /private/tmp, so we want
  # to dereference the symlink here to make the test work.
  local TMP="$(print -l /tmp(:A))"
  local TESTDIR=${TMP}/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap\ dir/test

  mkdir -p "${TESTDIR}"
  cd "${TESTDIR}"
  touch ../.needle
  touch ../../../.needle
  touch ../../../../.needle-noMatch
  touch ../../../../../../.needle
  touch ../../../../../../../../.needle

  local -a result
  # Modify internal field separator to newline, for easier
  # handling of paths with whitespaces.
  local OLDIFS="${IFS}"
  IFS=$'\n'
  result=( $(upsearch ".needle" $PWD) )
  IFS="${OLDIFS}"

  # Count array values
  assertEquals "4" "${#result}"

  # The Paths should be sorted by length. The innermost (longest) path should be returned first.
  assertEquals "${TMP}/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap dir/.needle" "${result[1]}"
  assertEquals "${TMP}/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/.needle" "${result[2]}"
  assertEquals "${TMP}/p9k-test/1/12/123/1234/12345/.needle" "${result[3]}"
  assertEquals "${TMP}/p9k-test/1/12/123/.needle" "${result[4]}"

  cd "${OLDPWD}"
  rm -fr "${TMP}/p9k-test"
}

function testUpsearchWithDirectories() {
  local OLDPWD="${PWD}"
  # On Mac /tmp is a symlink to /private/tmp, so we want
  # to dereference the symlink here to make the test work.
  local TMP="$(print -l /tmp(:A))"
  local TESTDIR=${TMP}/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap\ dir/test

  mkdir -p "${TESTDIR}"
  cd "${TESTDIR}"
  mkdir ../.needle
  mkdir ../../../.needle
  mkdir ../../../.needle-noMatch
  mkdir ../../../../../../.needle
  mkdir ../../../../../../../../.needle

  local -a result
  # Modify internal field separator to newline, for easier
  # handling of paths with whitespaces.
  local OLDIFS="${IFS}"
  IFS=$'\n'
  result=($(upsearch ".needle" $PWD))
  IFS="${OLDIFS}"

  # Count array values
  assertEquals "4" "${#result}"

  # The Paths should be sorted by length. The innermost (longest) path should be returned first.
  assertEquals "${TMP}/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap dir/.needle" "${result[1]}"
  assertEquals "${TMP}/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/.needle" "${result[2]}"
  assertEquals "${TMP}/p9k-test/1/12/123/1234/12345/.needle" "${result[3]}"
  assertEquals "${TMP}/p9k-test/1/12/123/.needle" "${result[4]}"

  cd "${OLDPWD}"
  rm -fr "${TMP}/p9k-test"
}

source shunit2/source/2.1/src/shunit2
