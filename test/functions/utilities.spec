#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  # Load Powerlevel9k
  source functions/utilities.zsh
  source functions/icons.zsh
  ################################################################
  # Source autoload functions
  ################################################################
  local autoload_path="$PWD/functions/autoload"
  # test if we already autoloaded the functions
  if [[ ${fpath[(ie)$autoload_path]} -gt ${#fpath} ]]; then
    fpath=( ${autoload_path} "${fpath[@]}" )
    autoload -Uz __p9k_segment_should_be_joined
    autoload -Uz __p9k_segment_should_be_printed
    autoload -Uz __p9k_truncate_path
    autoload -Uz __p9k_upsearch
  fi
}

function testDefinedFindsDefinedVariable() {
  my_var='X'

  assertTrue "p9k::defined 'my_var'"
  unset my_var
}

function testDefinedDoesNotFindUndefinedVariable() {
  assertFalse "p9k::defined 'my_var'"
}

function testSetDefaultSetsVariable() {
  p9k::set_default 'my_var' 'x'

  assertEquals 'x' "$my_var"
  unset my_var
}

function testPrintSizeHumanReadableWithBigNumber() {
  # Interesting: Currently we can't support numbers bigger than that.
  assertEquals '0.87E' "$(p9k::print_size_human_readable 1000000000000000000)"
}

function testPrintSizeHumanReadableWithExabytesAsBase() {
  assertEquals '9.77Z' "$(p9k::print_size_human_readable 10000 'E')"
}

function testGetRelevantItem() {
  typeset -a list
  list=(a b c)
  local callback='[[ "$item" == "b" ]] && echo "found"'

  local result=$(p9k::get_relevant_item "$list" "$callback")
  assertEquals 'found' "$result"

  unset list
}

function testGetRelevantItemDoesNotReturnNotFoundItems() {
  typeset -a list
  list=(a b c)
  local callback='[[ "$item" == "d" ]] && echo "found"'

  local result=$(p9k::get_relevant_item "$list" "$callback")
  assertEquals '' '' # whats this ?

  unset list
}

function testSegmentShouldBeJoinedIfDirectPredecessingSegmentIsJoined() {
  typeset -a segments
  segments=(a b_joined c_joined)
  # Look at the third segment
  local current_index=3
  local last_element_index=2

  local joined
  __p9k_segment_should_be_joined ${current_index} ${last_element_index} "$segments" && joined=true || joined=false
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
  __p9k_segment_should_be_joined ${current_index} ${last_element_index} "$segments" && joined=true || joined=false
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
  __p9k_segment_should_be_joined ${current_index} ${last_element_index} "$segments" && joined=true || joined=false
  assertFalse "$joined"

  unset segments
}

function testUpsearchWithFiles() {
  local OLDPWD="${PWD}"
  local TESTDIR=/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap\ dir/test

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
  result=($(__p9k_upsearch ".needle"))
  IFS="${OLDIFS}"

  # Count array values
  assertEquals "4" "${#result}"

  # The Paths should be sorted by length. The innermost (longest) path should be returned first.
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap dir" "${result[1]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678" "${result[2]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345" "${result[3]}"
  assertEquals "/tmp/p9k-test/1/12/123" "${result[4]}"

  cd "${OLDPWD}"
  rm -fr "/tmp/p9k-test"
}

function testUpsearchWithDirectories() {
  local OLDPWD="${PWD}"
  local TESTDIR=/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap\ dir/test

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
  result=($(__p9k_upsearch ".needle"))
  IFS="${OLDIFS}"

  # Count array values
  assertEquals "4" "${#result}"

  # The Paths should be sorted by length. The innermost (longest) path should be returned first.
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap dir" "${result[1]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678" "${result[2]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345" "${result[3]}"
  assertEquals "/tmp/p9k-test/1/12/123" "${result[4]}"

  cd "${OLDPWD}"
  rm -fr "/tmp/p9k-test"
}

function testUpsearchWithFileGlobs() {
  local OLDPWD="${PWD}"
  local TESTDIR=/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap\ dir/test

  mkdir -p "${TESTDIR}"
  cd "${TESTDIR}"
  mkdir ../.needle
  mkdir ../.another-needle
  touch ../../../.needle
  mkdir ../../../.needle-noMatch
  touch ../../../../../.another-needle
  touch ../../../../../../.needle
  mkdir ../../../../../../../../.needle

  local -a result
  # Modify internal field separator to newline, for easier
  # handling of paths with whitespaces.
  local OLDIFS="${IFS}"
  IFS=$'\n'
  # Alternative File syntax "(A|B)"    Glob qualifiers; "." is file; "/" is directory; "," means OR
  result=($(__p9k_upsearch "(.needle|.another-needle)" ".,/"))
  IFS="${OLDIFS}"

  # Count array values
  assertEquals "5" "${#result}"

  # The Paths should be sorted by length. The innermost (longest) path should be returned first.
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678/123456789/gap dir" "${result[1]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456/1234567/12345678" "${result[2]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345/123456" "${result[3]}"
  assertEquals "/tmp/p9k-test/1/12/123/1234/12345" "${result[4]}"
  assertEquals "/tmp/p9k-test/1/12/123" "${result[5]}"

  cd "${OLDPWD}"
  rm -fr "/tmp/p9k-test"
}

function testFindingFirstDefinedOrNonEmptyVariableNyName() {
  local var1=""
  local var2="some value"

  local result=

  assertEquals "" "$(p9k::find_first_defined var0 var1 var2)" # var1 value
  assertEquals "var1" "$(p9k::find_first_defined -n var0 var1 var2)" # var1 name

  assertEquals "some value" "$(p9k::find_first_non_empty var0 var1 var2)" # var2 value
  assertEquals "var2" "$(p9k::find_first_non_empty -n var0 var1 var2)" # var2 name

  local var0=""
  assertEquals "" "$(p9k::find_first_defined var0 var1 var2)" # var1 value
  assertEquals "var0" "$(p9k::find_first_defined -n var0 var1 var2)" # var1 name
  var0="other value"
  assertEquals "other value" "$(p9k::find_first_non_empty var0 var1 var2)" # var2 value
  assertEquals "var0" "$(p9k::find_first_non_empty -n var0 var1 var2)" # var2 name

  function internal() {
    local var0="qwe"
    assertEquals "qwe" "$(p9k::find_first_defined var0 var1 var2)" # var1 value
    assertEquals "var0" "$(p9k::find_first_defined -n var0 var1 var2)" # var1 name
    assertEquals "qwe" "$(p9k::find_first_non_empty var0 var1 var2)" # var2 value
    assertEquals "var0" "$(p9k::find_first_non_empty -n var0 var1 var2)" # var2 name
  }

  internal
}

source shunit2/shunit2
