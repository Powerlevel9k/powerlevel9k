#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  # Load Powerlevel9k
  source functions/colors.zsh
}

function testGetColorCodeWithAnsiForegroundColor() {
  assertEquals '002' "$(p9k::get_colorCode 'green')"
}

function testGetColorCodeWithAnsiBackgroundColor() {
  assertEquals '002' "$(p9k::get_colorCode 'bg-green')"
}

function testGetColorCodeWithNumericalColor() {
  assertEquals '002' "$(p9k::get_colorCode '002')"
}

function testIsSameColorComparesAnsiForegroundAndNumericalColorCorrectly() {
  assertTrue "p9k::is_same_color 'green' '002'"
}

function testIsSameColorComparesAnsiBackgroundAndNumericalColorCorrectly() {
  assertTrue "p9k::is_same_color 'bg-green' '002'"
}

#function testIsSameColorComparesNumericalBackgroundAndNumericalColorCorrectly() {
#  assertTrue "p9k::is_same_color '010' '2'"
#}

function testIsSameColorDoesNotYieldNotEqualColorsTruthy() {
  assertFalse "p9k::is_same_color 'green' '003'"
}


source shunit2/source/2.1/src/shunit2
