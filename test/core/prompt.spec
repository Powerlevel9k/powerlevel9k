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

function stripEsc() {
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
  local P9K_CUSTOM_WORLD2='echo world2'

  __p9k_prepare_prompts

  local _actual=$(stripEsc "${(e)RPROMPT}")
  assertEquals "%f%b%k%F{015}%K{015}%F{000} world1 %F{000}%K{015}%F{000} world2 %{<Esc>00m%" "${_actual}"
}

function testDisablingRightPrompt() {
  # Reset RPROMPT, so a running P9K does not interfere with the test
  local RPROMPT=
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_CUSTOM_WORLD2='echo world2'
  local P9K_DISABLE_RPROMPT=true

  __p9k_prepare_prompts

  assertEquals "" "${(e)RPROMPT}"
}

function testLeftMultilinePrompt() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'
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

  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_RPROMPT_ON_NEWLINE=false # We want the RPROMPT on the same line as our left prompt

  __p9k_prepare_prompts

  local _actual=$(stripEsc "${(e)RPROMPT}")
  assertEquals "%{<Esc>1A%}%f%b%k%F{015}%K{015}%F{000} world1 %{<Esc>00m%}%{<Esc>1B%" "${_actual}"
}

function testPrefixingFirstLineOnLeftPrompt() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'

  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON='XXX'
  source functions/icons.zsh

  __p9k_prepare_prompts

  local nl=$'\n'
  assertEquals "XXX%f%b%k%K{015} %F{000}world1 %k%F{015}%f ${nl}╰─ " "${(e)PROMPT}"
}

function testPrefixingSecondLineOnLeftPrompt() {
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'

  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON='XXX'
  source functions/icons.zsh

  __p9k_prepare_prompts

  local nl=$'\n'
  assertEquals "╭─%f%b%k%K{015} %F{000}world1 %k%F{015}%f ${nl}XXX" "${(e)PROMPT}"
}

function testCustomStartEndSymbolsOnEdgeSegments() {
  # Reset RPROMPT, so a running P9K does not interfere with the test
  local PROMPT=
  local RPROMPT=
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_CUSTOM_WORLD2='echo world2'

  local P9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL="_[_"
  local P9K_LEFT_PROMPT_FIRST_SEGMENT_START_WHITESPACE="_A_"
  local P9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL="_]_"
  local P9K_RIGHT_PROMPT_LAST_SEGMENT_END_WHITESPACE="_B_"

  __p9k_prepare_prompts

  assertEquals "%f%b%k%K{NONE}%F{015}_[_%K{015}_A_%F{000}world1  %F{000}world2 %k%F{015}%f " "${(e)PROMPT}"
  local _right=$(stripEsc "${(e)RPROMPT}")
  assertEquals "%f%b%k%F{015}%K{015}%F{000} world1 %F{000}%K{015}%F{000} world2_B_%K{none}%F{015}_]_%{<Esc>00m%" "${_right}"
}

function testCustomWhitespaceOfSegments() {
  # Reset RPROMPT, so a running P9K does not interfere with the test
  local PROMPT=
  local RPROMPT=
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_CUSTOM_WORLD1_ICON='{1}'
  local P9K_CUSTOM_WORLD2='echo world1'
  local P9K_CUSTOM_WORLD3='echo world3'

  local P9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS="_A_"
  local P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS="_B_"
  local P9K_LEFT_WHITESPACE_OF_LEFT_SEGMENTS="_C_"
  local P9K_RIGHT_WHITESPACE_OF_LEFT_SEGMENTS="_D_"
  local P9K_LEFT_WHITESPACE_OF_RIGHT_SEGMENTS="_E_"
  local P9K_RIGHT_WHITESPACE_OF_RIGHT_SEGMENTS="_F_"

  local P9K_CUSTOM_WORLD1_RIGHT_WHITESPACE="_G_"
  local P9K_CUSTOM_WORLD3_LEFT_WHITESPACE="_H_"

  __p9k_prepare_prompts

  assertEquals "%f%b%k%K{015}_C_%F{000}{1}%f_A_%F{000}world1_G__C_%F{000}world1_D__H_%F{000}world3_D_%k%F{015}%f " "${(e)PROMPT}"
  local _right=$(stripEsc "${(e)RPROMPT}")
  assertEquals "%f%b%k%F{015}%K{015}%F{000}_G_world1_B_%F{000}{1}%f_G_%F{000}%K{015}%F{000}_E_world1_F_%F{000}%K{015}%F{000}_E_world3_B_%{<Esc>00m%" "${_right}"
  
  local P9K_RPROMPT_ICON_LEFT=true

  __p9k_prepare_prompts
  _right=$(stripEsc "${(e)RPROMPT}")
  
  assertEquals "%f%b%k%F{015}%K{015}%F{000}_G_%F{000}{1}%f_B_world1_G_%F{000}%K{015}%F{000}_E_world1_F_%F{000}%K{015}%F{000}_E_world3_B_%{<Esc>00m%" "${_right}"
}

# !!! keep this last test in this file !!!
test_unfunction_stripEsc() {
  unfunction stripEsc
}

source shunit2/shunit2
