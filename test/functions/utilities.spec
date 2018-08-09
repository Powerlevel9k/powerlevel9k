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

function testDefinedDoesNotFindUnp9k::definedVariable() {
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

source shunit2/shunit2
