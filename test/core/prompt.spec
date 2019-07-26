#!/usr/bin/env zsh
#vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# Required for shunit2 to run correctly
setopt shwordsplit
SHUNIT_PARENT=$0

function setUp() {
  export TERM="xterm-256color"
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=()
  # Load Powerlevel9k
  source powerlevel9k.zsh-theme
}

function oneTimeSetUp() {
  function stripEsc() {
    local clean_string="" escape_found=false
    for (( i = 1; i <= ${#1}; i++ )); do
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
}

function oneTimeTearDown() {
  unfunction stripEsc
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
  assertEquals "%f%b%k%F{015}%K{015}%F{000} world1 %F{000}%K{015}%F{000} world2 %f%k%b" "${_actual}"
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
  # Fake environment
  local COlUMNS=10

  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'
  local P9K_PROMPT_ON_NEWLINE=true

  __p9k_prepare_prompts

  local nl=$'\n'
  local _actual=$(stripEsc "${(e)PROMPT}")
  assertEquals "%f%b%k╭─%K{015} %F{000}world1 %k%F{015}%f                                                                     %f%b%k${nl}╰─ " "${_actual}"
}

function testRightPromptOnSameLine() {
  # Fake environment
  local COLUMNS=10
  # Reset PROMPT, so a running P9K does not interfere with the test
  local PROMPT=
  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=()
  local -a P9K_RIGHT_PROMPT_ELEMENTS
  P9K_RIGHT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'

  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_RPROMPT_ON_NEWLINE=false # We want the RPROMPT on the same line as our left prompt

  __p9k_prepare_prompts

  local nl=$'\n'
  # The right prompt gets integrated in the left prompt in
  # this setup, hence we have to test PROMPT instead of RPROMPT.
  local _actual=$(stripEsc "${(e)PROMPT}")
  assertEquals "%f%b%k╭─ %f%b%k%F{015}%K{015}%F{000} world1 %f%k%b${nl}╰─ " "${_actual}"
}

function testPrefixingFirstLineOnLeftPrompt() {
  # Fake environment
  local COLUMNS=10

  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'

  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_MULTILINE_FIRST_PROMPT_PREFIX_ICON='XXX'
  source functions/icons.zsh

  __p9k_prepare_prompts

  local nl=$'\n'
  local _actual=$(stripEsc "${(e)PROMPT}")
  assertEquals "%f%b%kXXX%K{015} %F{000}world1 %k%F{015}%f    %f%b%k${nl}╰─ " "${_actual}"
}

function testPrefixingSecondLineOnLeftPrompt() {
  # Fake environment
  local COLUMNS=10

  local -a P9K_LEFT_PROMPT_ELEMENTS
  P9K_LEFT_PROMPT_ELEMENTS=(custom_world1)
  local P9K_CUSTOM_WORLD1='echo world1'

  local P9K_PROMPT_ON_NEWLINE=true
  local P9K_MULTILINE_LAST_PROMPT_PREFIX_ICON='XXX'
  source functions/icons.zsh

  __p9k_prepare_prompts

  local nl=$'\n'
  local _actual=$(stripEsc "${(e)PROMPT}")
  assertEquals "%f%b%k╭─%K{015} %F{000}world1 %k%F{015}%f   %f%b%k
XXX" "${_actual}"
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

  assertEquals "%K{NONE}%F{015}_[_%K{015}_A_%F{000}\${:-\"world1\"}  %F{000}\${:-\"world2\"} %k%F{015}%f " "$(__p9k_build_left_prompt)"
  local _right=$(stripEsc "$(__p9k_build_right_prompt)")
  assertEquals "%F{015}%K{015}%F{000} \${:-\"world1\"} %F{000}%K{015}%F{000} \${:-\"world2\"}_B_%K{none}%F{015}_]_%f%k%b" "${_right}"
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
  local P9K_MIDDLE_WHITESPACE_OF_LEFT_SEGMENTS="_[M]_"

  local P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS="_[R]_"
  local P9K_MIDDLE_WHITESPACE_OF_RIGHT_SEGMENTS="_[M]_"

  assertEquals "%K{015}_[L]_%F{000}{1}_[M]_%F{000}\${:-\"world1\"}_[L]__[L]_%F{000}\${:-\"world2\"}_[L]__[L]_%F{000}{3}_[M]_%F{000}\${:-\"world3\"}_[L]_%k%F{015}%f " "$(__p9k_build_left_prompt)"
  assertEquals "%F{015}%K{015}%F{000}_[R]_\${:-\"world1\"}_[M]_%F{000}{1}%f_[R]_%F{000}%K{015}%F{000}_[R]_\${:-\"world2\"}_[R]_%F{000}%K{015}%F{000}_[R]_\${:-\"world3\"}_[M]_%F{000}{3}%f_[R]_%f%k%b" "$(stripEsc "$(__p9k_build_right_prompt)")"
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

  assertEquals "%K{015}_[LL]_%F{000}{1}_[LM]_%F{000}\${:-\"world1\"}_[LR]__[LL]_%F{000}\${:-\"world2\"}_[LR]__[LL]_%F{000}{3}_[LM]_%F{000}\${:-\"world3\"}_[LR]_%k%F{015}%f " "$(__p9k_build_left_prompt)"
  assertEquals "%F{015}%K{015}%F{000}_[RL]_\${:-\"world1\"}_[RM]_%F{000}{1}%f_[RR]_%F{000}%K{015}%F{000}_[RL]_\${:-\"world2\"}_[RR]_%F{000}%K{015}%F{000}_[RL]_\${:-\"world3\"}_[RM]_%F{000}{3}%f_[RR]_%f%k%b" "$(stripEsc "$(__p9k_build_right_prompt)")"
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

  assertEquals "%K{015}_[L1]_%F{000}{1}_[M1]_%F{000}\${:-\"world1\"}_[R1]__[L2]_%F{000}\${:-\"world2\"}_[R2]__[L3]_%F{000}{3}_[M3]_%F{000}\${:-\"world3\"}_[R3]_%k%F{015}%f " "$(__p9k_build_left_prompt)"
  assertEquals "%F{015}%K{015}%F{000}_[L1]_\${:-\"world1\"}_[M1]_%F{000}{1}%f_[R1]_%F{000}%K{015}%F{000}_[L2]_\${:-\"world2\"}_[R2]_%F{000}%K{015}%F{000}_[L3]_\${:-\"world3\"}_[M3]_%F{000}{3}%f_[R3]_%f%k%b" "$(stripEsc "$(__p9k_build_right_prompt)")"
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
  
  local P9K_MIDDLE_WHITESPACE_OF_RIGHT_SEGMENTS="_[M]_"
  local P9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS="_[R]_"

  assertEquals "%F{015}%K{015}%F{000}_[R]_%F{000}{1}%f_[M]_%F{000}\${:-\"world1\"}_[R]_%F{000}%K{015}%F{000}_[R]_%F{000}\${:-\"world2\"}_[R]_%F{000}%K{015}%F{000}_[R]_%F{000}{3}%f_[M]_%F{000}\${:-\"world3\"}_[R]_%f%k%b" "$(stripEsc "$(__p9k_build_right_prompt)")"
}

source shunit2/shunit2
