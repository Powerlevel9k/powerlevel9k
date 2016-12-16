#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  # Load Powerlevel9k
  source functions/icons.zsh
  source functions/utilities.zsh
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
  set_default 'my_var' 'x'

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

source shunit2/source/2.1/src/shunit2
