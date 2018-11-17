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
  local P9K_CUSTOM_WORLD2='echo world2'
  local P9K_CUSTOM_WORLD3='echo world3'
  local P9K_CUSTOM_WORLD3_ICON='{3}'

  local P9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS="_[L]_"
  local P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS="_[R]_"

  __p9k_prepare_prompts
  assertEquals "%f%b%k%K{015}_[L]_%F{000}{1}%f_[L]_%F{000}world1_[L]__[L]_%F{000}world2_[L]__[L]_%F{000}{3}%f_[L]_%F{000}world3_[L]_%k%F{015}%f " "${(e)PROMPT}"
  assertEquals "%f%b%k%F{015}%K{015}%F{000}_[R]_world1_[R]_%F{000}{1}%f_[R]_%F{000}%K{015}%F{000}_[R]_world2_[R]_%F{000}%K{015}%F{000}_[R]_world3_[R]_%F{000}{3}%f_[R]_%{<Esc>00m%" "$(stripEsc "${(e)RPROMPT}")"

}

function testCustomWhitespaceOfLeftAndRightSegments() {
  # Reset RPROMPT, so a running P9K does not interfere with the test
  local PROMPT=
  local RPROMPT=
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_CUSTOM_WORLD1_ICON='{1}'
  local P9K_CUSTOM_WORLD2='echo world2'
  local P9K_CUSTOM_WORLD3='echo world3'
  local P9K_CUSTOM_WORLD3_ICON='{3}'
  
  local P9K_LEFT_WHITESPACE_OF_LEFT_SEGMENTS="_[LL]_"
  local P9K_MIDDLE_WHITESPACE_OF_LEFT_SEGMENTS="_[LM]_"
  local P9K_RIGHT_WHITESPACE_OF_LEFT_SEGMENTS="_[LR]_"

  local P9K_LEFT_WHITESPACE_OF_RIGHT_SEGMENTS="_[RL]_"
  local P9K_MIDDLE_WHITESPACE_OF_RIGHT_SEGMENTS="_[RM]_"
  local P9K_RIGHT_WHITESPACE_OF_RIGHT_SEGMENTS="_[RR]_"

    __p9k_prepare_prompts
  assertEquals "%f%b%k%K{015}_[LL]_%F{000}{1}%f_[LM]_%F{000}world1_[LR]__[LL]_%F{000}world2_[LR]__[LL]_%F{000}{3}%f_[LM]_%F{000}world3_[LR]_%k%F{015}%f " "${(e)PROMPT}"
  assertEquals "%f%b%k%F{015}%K{015}%F{000}_[RL]_world1_[RM]_%F{000}{1}%f_[RR]_%F{000}%K{015}%F{000}_[RL]_world2_[RR]_%F{000}%K{015}%F{000}_[RL]_world3_[RM]_%F{000}{3}%f_[RR]_%{<Esc>00m%" "$(stripEsc "${(e)RPROMPT}")"

}

function testCustomWhitespaceOfCustomSegments() {
  # Reset RPROMPT, so a running P9K does not interfere with the test
  local PROMPT=
  local RPROMPT=
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_CUSTOM_WORLD1_ICON='{1}'
  local P9K_CUSTOM_WORLD2='echo world2'
  local P9K_CUSTOM_WORLD3='echo world3'
  local P9K_CUSTOM_WORLD3_ICON='{3}'
  
  local P9K_CUSTOM_WORLD1_LEFT_WHITESPACE="_[L1]_"
  local P9K_CUSTOM_WORLD1_MIDDLE_WHITESPACE="_[M1]_"
  local P9K_CUSTOM_WORLD1_RIGHT_WHITESPACE="_[R1]_"

  local P9K_CUSTOM_WORLD2_LEFT_WHITESPACE="_[L2]_"
  local P9K_CUSTOM_WORLD2_MIDDLE_WHITESPACE="_[M2]_"
  local P9K_CUSTOM_WORLD2_RIGHT_WHITESPACE="_[R2]_"

  local P9K_CUSTOM_WORLD3_LEFT_WHITESPACE="_[L3]_"
  local P9K_CUSTOM_WORLD3_MIDDLE_WHITESPACE="_[M3]_"
  local P9K_CUSTOM_WORLD3_RIGHT_WHITESPACE="_[R3]_"

    __p9k_prepare_prompts
  assertEquals "%f%b%k%K{015}_[L1]_%F{000}{1}%f_[M1]_%F{000}world1_[R1]__[L2]_%F{000}world2_[R2]__[L3]_%F{000}{3}%f_[M3]_%F{000}world3_[R3]_%k%F{015}%f " "${(e)PROMPT}"
  assertEquals "%f%b%k%F{015}%K{015}%F{000}_[R1]_world1_[M1]_%F{000}{1}%f_[R1]_%F{000}%K{015}%F{000}_[R2]_world2_[R2]_%F{000}%K{015}%F{000}_[R3]_world3_[M3]_%F{000}{3}%f_[R3]_%{<Esc>00m%" "$(stripEsc "${(e)RPROMPT}")"

}

function testCustomWhitespaceWithIconOnLeft() {
  # Reset RPROMPT, so a running P9K does not interfere with the test
  local PROMPT=
  local RPROMPT=
  local -a P9K_LEFT_PROMPT_ELEMENTS
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1 custom_world2 custom_world3)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_CUSTOM_WORLD1_ICON='{1}'
  local P9K_CUSTOM_WORLD2='echo world2'
  local P9K_CUSTOM_WORLD3='echo world3'
  local P9K_CUSTOM_WORLD3_ICON='{3}'
  
  local P9K_RPROMPT_ICON_LEFT=true
  
  local P9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS="_[L]_"
  local P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS="_[R]_"

  __p9k_prepare_prompts
  assertEquals "%f%b%k%F{015}%K{015}%F{000}_[R]_%F{000}{1}%f_[R]_%F{000}world1_[R]_%F{000}%K{015}%F{000}_[R]_%F{000}world2_[R]_%F{000}%K{015}%F{000}_[R]_%F{000}{3}%f_[R]_%F{000}world3_[R]_%{<Esc>00m%" "$(stripEsc "${(e)RPROMPT}")"
}

# !!! keep this last test in this file !!!
test_unfunction_stripEsc() {
  unfunction stripEsc
}

source shunit2/shunit2
