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

stripEsc() {
  local clean_string="" escape_found=false
  for (( i = 0; i < ${#1}; i++ )); do
    case ${1[i]}; in
      "")  clean_string+="<Esc>"; escape_found=true ;; # escape character
      "[")  if [[ $escape_found == true ]]; then
              escape_found=false
            else
              clean_string+="${1[i]}"
            fi
            ;;
      *)    clean_string+="${1[i]}" ;;
    esac
  done
  echo "${clean_string}"
}

function testSegmentOnRightSide() {
    # Reset RPROMPT, so a running P9K does not interfere with the test
    local RPROMPT=
    local -a P9K_RIGHT_PROMPT_ELEMENTS
    P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
    local P9K_CUSTOM_WORLD1='echo world1'
    p9k::register_segment "WORLD1"
    local P9K_CUSTOM_WORLD2='echo world2'
    p9k::register_segment "WORLD2"

    __p9k_prepare_prompts

    local reset_attributes=$'\e[00m'
    #             %f%b%k%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world2 %F{black} %{%}
    assertEquals "%f%b%k%F{white}%K{white}%F{black} world1 %F{black} %F{black}%K{white}%F{black} world2 %F{black} %{${reset_attributes}%}" "${(e)RPROMPT}"
}

function testDisablingRightPrompt() {
    # Reset RPROMPT, so a running P9K does not interfere with the test
    local RPROMPT=
    local -a P9K_RIGHT_PROMPT_ELEMENTS
    P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
    local P9K_CUSTOM_WORLD1='echo world1'
    p9k::register_segment "WORLD1"
    local P9K_CUSTOM_WORLD2='echo world2'
    p9k::register_segment "WORLD2"
    local P9K_DISABLE_RPROMPT=true

    __p9k_prepare_prompts

    assertEquals "" "${(e)RPROMPT}"
}

function testLeftMultilinePrompt() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    p9k::register_segment "WORLD1"
    local P9K_PROMPT_ON_NEWLINE=true

    __p9k_prepare_prompts

    local nl=$'\n'
    assertEquals "╭─%f%b%k%K{white} %F{black}world1 %k%F{white}%f ${nl}╰─ " "${(e)PROMPT}"
}

function testRightPromptOnSameLine() {
    # Reset RPROMPT, so a running P9K does not interfere with the test
    local RPROMPT=
    local -a P9K_RIGHT_PROMPT_ELEMENTS
    P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    p9k::register_segment "WORLD1"

    local P9K_PROMPT_ON_NEWLINE=true
    local P9K_RPROMPT_ON_NEWLINE=false # We want the RPROMPT on the same line as our left prompt

    # Skip test, as this cannot be tested properly.
    # The "go one line up" instruction does not get
    # printed as real characters in RPROMPT.
    # On command line the assert statement produces
    # a visually identical output as we expect, but
    # it fails anyway. :(
    startSkipping

    __p9k_prepare_prompts

    local _actual="$(stripEsc "${(e)RPROMPT}")"
    local _expected="%{<Esc>1A%}%f%b%k%F{white}%K{white}%F{black} world1 %F{black} %{<Esc>00m%}%{<Esc>1B%"
    assertEqualsEsc "${_expected}" "${_actual}"
}

function testPrefixingFirstLineOnLeftPrompt() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    p9k::register_segment "WORLD1"

    local P9K_PROMPT_ON_NEWLINE=true
    local P9K_MULTILINE_FIRST_PROMPT_PREFIX='XXX'
    source functions/icons.zsh

    __p9k_prepare_prompts

    local nl=$'\n'
    assertEquals "XXX%f%b%k%K{white} %F{black}world1 %k%F{white}%f ${nl}╰─ " "${(e)PROMPT}"
}

function testPrefixingSecondLineOnLeftPrompt() {
    local -a P9K_LEFT_PROMPT_ELEMENTS
    P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
    local P9K_CUSTOM_WORLD1='echo world1'
    p9k::register_segment "WORLD1"

    local P9K_PROMPT_ON_NEWLINE=true
    local P9K_MULTILINE_LAST_PROMPT_PREFIX='XXX'
    source functions/icons.zsh

    __p9k_prepare_prompts

    local nl=$'\n'
    assertEquals "╭─%f%b%k%K{white} %F{black}world1 %k%F{white}%f ${nl}XXX" "${(e)PROMPT}"
}

source shunit2/shunit2
