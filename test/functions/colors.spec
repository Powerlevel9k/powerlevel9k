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
  assertEquals '002' "$(p9k::get_color_code 'green')"
}

function testGetColorCodeWithAnsiBackgroundColor() {
  assertEquals '002' "$(p9k::get_color_code 'bg-green')"
}

function testGetColorCodeWithNumericalColor() {
  assertEquals '002' "$(p9k::get_color_code '002')"
}

function testGetColorCodeWithNoneColor() {
  assertEquals 'none' "$(p9k::get_color_code 'NONE')"
}

function testIsSameColorComparesAnsiForegroundAndNumericalColorCorrectly() {
  assertTrue "p9k::is_same_color 'green' '002'"
}

function testIsSameColorComparesAnsiBackgroundAndNumericalColorCorrectly() {
  assertTrue "p9k::is_same_color 'bg-green' '002'"
}

function testIsSameColorComparesShortCodesCorrectly() {
  assertTrue "p9k::is_same_color '002' '2'"
}

function testIsSameColorDoesNotYieldNotEqualColorsTruthy() {
  assertFalse "p9k::is_same_color 'green' '003'"
}

function testIsSameColorHandlesNoneCorrectly() {
  assertTrue "p9k::is_same_color 'none' 'NOnE'"
}

function testIsSameColorCompareTwoNoneColorsCorrectly() {
  assertTrue "p9k::is_same_color 'none' 'none'"
}

function testIsSameColorComparesColorWithNoneCorrectly() {
  assertFalse "p9k::is_same_color 'green' 'none'"
}

function testBrightColorsWork() {
  # We had some code in the past that equalized bright colors
  # with normal ones. This code is now gone, and this test should
  # ensure that all input channels for bright colors are handled
  # correctly.
  assertTrue "p9k::is_same_color 'cyan' '006'"
  assertEquals '006' "$(p9k::get_color_code 'cyan')"
  assertEquals '006' "$(p9k::get_color 'cyan')"
}

source shunit2/shunit2
