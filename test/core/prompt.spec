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
      "[")  if [[ ${escape_found} == true ]]; then
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

  local _actual=$(stripEsc "${(e)RPROMPT}")
  assertEquals "%f%b%k%F{015}%K{015}%F{000} world1 %F{000} %F{000}%K{015}%F{000} world2 %F{000} %{<Esc>00m%" "${_actual}"
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
  assertEquals "╭─%f%b%k%K{015} %F{000}world1 %k%F{015}%f ${nl}╰─ " "${(e)PROMPT}"
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

  __p9k_prepare_prompts

  local _actual=$(stripEsc "${(e)RPROMPT}")
  assertEquals "%{<Esc>1A%}%f%b%k%F{015}%K{015}%F{000} world1 %F{000} %{<Esc>00m%}%{<Esc>1B%" "${_actual}"
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
  assertEquals "XXX%f%b%k%K{015} %F{000}world1 %k%F{015}%f ${nl}╰─ " "${(e)PROMPT}"
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
  assertEquals "╭─%f%b%k%K{015} %F{000}world1 %k%F{015}%f ${nl}XXX" "${(e)PROMPT}"

  unfunction stripEsc
}

source shunit2/shunit2
