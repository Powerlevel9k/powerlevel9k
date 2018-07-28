#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function testSegmentOnRightSide() {
    # Reset RPROMPT, so a running P9K does not interfere with the test
    local RPROMPT=
    local -a P9K_RIGHT_PROMPT_ELEMENTS
    P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
    local P9K_CUSTOM_WORLD1='echo world1'
    registerSegment "WORLD1"
    local P9K_CUSTOM_WORLD2='echo world2'
    registerSegment "WORLD2"

    p9kPreparePrompts

    local reset_attributes=$'\e[00m'
    assertEquals "%f%b%k%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world2 %F{black} %{${reset_attributes}%}" "${(e)RPROMPT}"
}

function testDisablingRightPrompt() {
    # Reset RPROMPT, so a running P9K does not interfere with the test
    local RPROMPT=
    local -a P9K_RIGHT_PROMPT_ELEMENTS
    P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
    local P9K_CUSTOM_WORLD1='echo world1'
    registerSegment "WORLD1"
    local P9K_CUSTOM_WORLD2='echo world2'
    registerSegment "WORLD2"
    local P9K_DISABLE_RPROMPT=true

    p9kPreparePrompts

    assertEquals "" "${(e)RPROMPT}"
}

function testLeftMultilinePrompt() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    registerSegment "WORLD1"
    local P9K_PROMPT_ON_NEWLINE=true

    p9kPreparePrompts

    local nl=$'\n'
    assertEquals "╭─%f%b%k%K{white} %F{black}world1 %k%F{white}%f ${nl}╰─ " "${(e)PROMPT}"
}

function testRightPromptOnSameLine() {
    # Reset RPROMPT, so a running P9K does not interfere with the test
    local RPROMPT=
    local -a P9K_RIGHT_PROMPT_ELEMENTS
    P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    registerSegment "WORLD1"

    local P9K_PROMPT_ON_NEWLINE=true
    local P9K_RPROMPT_ON_NEWLINE=false # We want the RPROMPT on the same line as our left prompt

    # Skip test, as this cannot be tested properly.
    # The "go one line up" instruction does not get
    # printed as real characters in RPROMPT.
    # On command line the assert statement produces
    # a visually identical output as we expect, but
    # it fails anyway. :(
    startSkipping

    p9kPreparePrompts
    assertEquals "%{\e[1A%}%F{white}%K{white}%F{black} world1 %f%{\e[1B%}" "${(e)RPROMPT}"
}

function testPrefixingFirstLineOnLeftPrompt() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    registerSegment "WORLD1"

    local P9K_PROMPT_ON_NEWLINE=true
    local P9K_MULTILINE_FIRST_PROMPT_PREFIX='XXX'
    source functions/icons.zsh

    p9kPreparePrompts

    local nl=$'\n'
    assertEquals "XXX%f%b%k%K{white} %F{black}world1 %k%F{white}%f ${nl}╰─ " "${(e)PROMPT}"
}

function testPrefixingSecondLineOnLeftPrompt() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    registerSegment "WORLD1"

    local P9K_PROMPT_ON_NEWLINE=true
    local P9K_MULTILINE_LAST_PROMPT_PREFIX='XXX'
    source functions/icons.zsh

    p9kPreparePrompts

    local nl=$'\n'
    assertEquals "╭─%f%b%k%K{white} %F{black}world1 %k%F{white}%f ${nl}XXX" "${(e)PROMPT}"
}

source shunit2/source/2.1/src/shunit2
