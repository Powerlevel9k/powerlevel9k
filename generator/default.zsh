#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
# DEFAULT ENGINE

################################################################
# Prompt Segment Constructors
#
# Methodology behind user-defined variables overwriting colors:
#     The first parameter to the segment constructors is the calling function's
#     name. From this function name, we strip the "prompt_"-prefix and
#     uppercase it. This is then prefixed with "POWERLEVEL9K_" and suffixed
#     with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
#     name. So each new segment is user-overwritten by a variable following
#     this naming convention.
################################################################

################################################################
# A helper function to determine if a segment should be
# joined or promoted to a full one.
# Takes three arguments:
#   * $1: The array index of the current segment
#   * $2: The array index of the last printed segment
#   * $3: The array of segments of the left or right prompt
function segmentShouldBeJoined() {
  if [[ $8 == "false" ]]; then
    last_left_element_index=$current_index
    return
  fi

  local current_index=$1
  local last_segment_index=$2
  # Explicitly split the elements by whitespace.
  local -a elements
  elements=(${=3})

  local current_segment=${elements[$current_index]}
  local joined=false
  if [[ ${current_segment[-7,-1]} == '_joined' ]]; then
    joined=true
    # promote segment to a full one, if the predecessing full segment
    # was conditional. So this can only be the case for segments that
    # are not our direct predecessor.
    if (( $(($current_index - $last_segment_index)) > 1)); then
      # Now we have to examine every previous segment, until we reach
      # the last printed one (found by its index). This is relevant if
      # all previous segments are joined. Then we want to join our
      # segment as well.
      local examined_index=$((current_index - 1))
      while (( $examined_index > $last_segment_index )); do
        local previous_segment=${elements[$examined_index]}
        # If one of the examined segments is not joined, then we know
        # that the current segment should not be joined, as the target
        # segment is the wrong one.
        if [[ ${previous_segment[-7,-1]} != '_joined' ]]; then
          joined=false
          break
        fi
        examined_index=$((examined_index - 1))
      done
    fi
  fi

  # Return 1 means error; return 0 means no error. So we have
  # to invert $joined
  if [[ "$joined" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

###############################################################
# Begin a left prompt segment
# Takes four arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: Bold
#   * $6: The segment content
#   * $7: An identifying icon (must be a key of the icons array)
#   * $8: Should the segment be shown?
# The latter three can be omitted,
set_default last_left_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
left_prompt_segment() {
  [[ $8 == "false" ]] && return

  local current_index=$2
  # Check if the segment should be joined with the previous one
  local joined
  segmentShouldBeJoined $current_index $last_left_element_index "$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS" && joined=true || joined=false

  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 3="$BG_COLOR_MODIFIER"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 4="$FG_COLOR_MODIFIER"

  local bg fg bd
  [[ -n "$3" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "$4" ]] && fg="%F{$4}" || fg="%f"
  [[ ${(L)5} == "true" ]] && bd="%B" || bd=""

  if [[ $CURRENT_BG != 'NONE' ]] && ! isSameColor "$3" "$CURRENT_BG"; then
    echo -n "$bg%F{$CURRENT_BG}"
    if [[ $joined == false ]]; then
      # Middle segment
      echo -n "$(print_icon 'LEFT_SEGMENT_SEPARATOR')$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
    fi
  elif isSameColor "$CURRENT_BG" "$3"; then
    # Middle segment with same color as previous segment
    # We take the current foreground color as color for our
    # subsegment (or the default color). This should have
    # enough contrast.
    local complement
    [[ -n "$4" ]] && complement="$4" || complement=$DEFAULT_COLOR
    echo -n "$bg%F{$complement}"
    if [[ $joined == true ]]; then
      echo -n "$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
    fi
  else
    # First segment
    echo -n "${bg}$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
  fi

  # Print the visual identifier
  echo -n "${7}"
  # Print the content of the segment, if there is any
  [[ -n "$6" ]] && echo -n "${fg}${bd}${6}%b${bg}${fg}"
  echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"

  CURRENT_BG=$3
  last_left_element_index=$current_index
}

###############################################################
# End the left prompt, closes the final segment.
left_prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%k%F{$CURRENT_BG}$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  else
    echo -n "%k"
  fi
  echo -n "%f$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  CURRENT_BG=''
}

CURRENT_RIGHT_BG='NONE'

###############################################################
# Begin a right prompt segment
# Takes four arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: Bold
#   * $6: The segment content
#   * $7: An identifying icon (must be a key of the icons array)
#   * $8: Should the segment be shown?
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default last_right_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  local current_index=$2

  [[ $8 == "false" ]] && return # exit if segment shouldn't be shown
  # Check if the segment should be joined with the previous one
  local joined
  segmentShouldBeJoined $current_index $last_right_element_index "$POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS" && joined=true || joined=false

  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && 3="$BG_COLOR_MODIFIER"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)1#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && 4="$FG_COLOR_MODIFIER"

  local bg fg bd
  [[ -n "$3" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "$4" ]] && fg="%F{$4}" || fg="%f"
  [[ ${(L)5} == "true" ]] && bd="%B" || bd=""

  # If CURRENT_RIGHT_BG is "NONE", we are the first right segment.
  if [[ "$CURRENT_RIGHT_BG" == "NONE" ]]; then
    echo -n "%F{$3}$(print_icon 'RIGHT_SEGMENT_SEPARATOR')%f"
  else # all other segments
    if [[ $joined == "false" ]]; then # not joined
      if isSameColor "$CURRENT_RIGHT_BG" "$3"; then
        # Middle segment with same color as previous segment
        # We take the current foreground color as color for our
        # subsegment (or the default color). This should have
        # enough contrast.
        local complement
        [[ -n "$4" ]] && complement="$4" || complement=$DEFAULT_COLOR
        echo -n "%F{$complement}$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')%f"
      else
        echo -n "%F{$3}$(print_icon 'RIGHT_SEGMENT_SEPARATOR')%f"
      fi
    fi
  fi

  echo -n "${bg}${fg}"

  if [[ $POWERLEVEL9K_RPROMPT_ICON_LEFT ]]; then
    # Print the visual identifier
    echo -n "${7}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
    # Print segment content
    echo -n "${bg}${fg}${bd}${6}%b${bg}${fg}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"
  else
    # Print whitespace only if segment is not joined or first right segment
    [[ ${joined} == false ]] || [[ "${CURRENT_RIGHT_BG}" == "NONE" ]] && echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
    # Print segment content if there is any
    [[ -n "$6" ]] && echo -n "${bd}${6}%n${bg}${fg}"
    # Print the visual identifier
    echo -n "${7}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"
  fi

  CURRENT_RIGHT_BG=$3
  last_right_element_index=$current_index
}

################################################################
# Prompt processing and drawing
################################################################

###############################################################
# Main prompt
build_left_prompt() {
  local index=1
  for element in "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"; do
    # Remove joined information in direct calls
    element=${element%_joined}

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "left" "$index" $element[8,-1]
    else
      "prompt_$element" "left" "$index"
    fi

    index=$((index + 1))
  done

  left_prompt_end
}

###############################################################
# Right prompt
build_right_prompt() {
  local index=1
  for element in "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; do
    # Remove joined information in direct calls
    element=${element%_joined}

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "right" "$index" $element[8,-1]
    else
      "prompt_$element" "right" "$index"
    fi

    index=$((index + 1))
  done
}

###############################################################
powerlevel9k_preexec() {
  _P9K_TIMER_START=$EPOCHREALTIME
}

###############################################################
set_default POWERLEVEL9K_PROMPT_ADD_NEWLINE false
powerlevel9k_prepare_prompts() {
  RETVAL=$?

  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))
  # Reset start time - Maximum integer on 32-bit CPUs
  [[ "$ARCH" == "x64" ]] && _P9K_TIMER_START=99999999999 || _P9K_TIMER_START=2147483647
  # I decided to use the value above for better supporting 32-bit CPUs, since the previous value "99999999999" was
  # causing issues on my Android phone, which is powered by an armv7l
  # We don't have to change that until 19 January of 2038! :)


  if [[ "$POWERLEVEL9K_PROMPT_ON_NEWLINE" == true ]]; then
    PROMPT="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k$(build_left_prompt)
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    if [[ "$POWERLEVEL9K_RPROMPT_ON_NEWLINE" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt. To do so, there is just a quite ugly workaround: Before zsh draws
      # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
      # advise it to go one line down. See:
      # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
      local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters
      RPROMPT_PREFIX='%{'$'\e[1A''%}' # one line up
      RPROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
    else
      RPROMPT_PREFIX=''
      RPROMPT_SUFFIX=''
    fi
  else
    PROMPT="%f%b%k$(build_left_prompt)"
    RPROMPT_PREFIX=''
    RPROMPT_SUFFIX=''
  fi

  if [[ "$POWERLEVEL9K_DISABLE_RPROMPT" != true ]]; then
    RPROMPT="$RPROMPT_PREFIX%f%b%k$(build_right_prompt)%{$reset_color%}$RPROMPT_SUFFIX"
  fi
NEWLINE='
'
  [[ $POWERLEVEL9K_PROMPT_ADD_NEWLINE == true ]] && PROMPT="$NEWLINE$PROMPT"
}

###############################################################
# This function wraps left_prompt_segment and right_prompt_segment to serializes a segment (for compatibility with the async branch)
#
# Parameters for serialize_segment:
#   * $1 Name: string - Name of the segment
#   * $2 State: string - The state the segment is in
#   * $3 Alignment: string - left|right
#   * $4 Index: integer
#   * $5 Joined: bool - If the segment should be joined
#   * $6 Background: string - The default background color of the segment
#   * $7 Foreground: string - The default foreground color of the segment
#   * $8 Content: string - Content of the segment
#   * $9 Visual identifier: string - Icon of the segment
#   * $10 Condition: string - The condition, if the segment should be printed (gets evaluated)
#
# Parameters for [left|right]_prompt_segment:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: Bold
#   * $6: The segment content
#   * $7: An identifying icon (must be a key of the icons array)
# The latter three can be omitted,
serialize_segment() {
  local NAME="${1}"
  local STATE="${2}"
  local ALIGNMENT="${3}"
  local INDEX="${4}"
  local JOINED="${5}"

  local STATEFUL_NAME="${(U)NAME#prompt_}"
  [[ -n "${STATE}" ]] && STATEFUL_NAME="${STATEFUL_NAME}_${(U)STATE}"

  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE="POWERLEVEL9K_${STATEFUL_NAME}_BACKGROUND"
  local BACKGROUND="${(P)BACKGROUND_USER_VARIABLE}"
  [[ -z "${BACKGROUND}" ]] && BACKGROUND="${6}"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE="POWERLEVEL9K_${STATEFUL_NAME}_FOREGROUND"
  local FOREGROUND="${(P)FOREGROUND_USER_VARIABLE}"
  [[ -z "${FOREGROUND}" ]] && FOREGROUND="${7}"

  # Overwrite given bold directive by user defined variable for this segment.
  local BOLD_USER_VARIABLE="POWERLEVEL9K_${STATEFUL_NAME}_BOLD"
  local BOLD="${(P)BOLD_USER_VARIABLE}"
  [[ -z "${BOLD}" ]] && BOLD=false

  local CONTENT="${8}"

  local VISUAL_IDENTIFIER
  if [[ -n "${9}" ]]; then
    VISUAL_IDENTIFIER="$(print_icon ${9})"
    if [[ -n "${VISUAL_IDENTIFIER}" ]]; then
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable="POWERLEVEL9K_${STATEFUL_NAME}_VISUAL_IDENTIFIER_COLOR"
      set_default "${visual_identifier_color_variable}" "${FOREGROUND}"
      VISUAL_IDENTIFIER="%F{${(P)visual_identifier_color_variable}%}${VISUAL_IDENTIFIER}%f"
      # Add an whitespace if we print more than just the visual identifier
      if [[ -n "${CONTENT}" ]]; then
        [[ "${ALIGNMENT}" == "left" ]] && VISUAL_IDENTIFIER="${VISUAL_IDENTIFIER} "
        [[ "${ALIGNMENT}" == "right" ]] && VISUAL_IDENTIFIER=" ${VISUAL_IDENTIFIER}"
      fi
    fi
  fi
  # Conditions have three layers:
  # 1. All segments should not print
  #    a segment, if they provide no
  #    content (default condition).
  # 2. All segments could define a
  #    default condition on their
  #    own, overriding the previous
  #    one.
  # 3. Users could set a condition
  #    for each segment. This is
  #    the trump card, and has
  #    highest precedence.
  local CONDITION
  local SEGMENT_CONDITION="POWERLEVEL9K_${STATEFUL_NAME}_CONDITION"
  if defined "${SEGMENT_CONDITION}"; then
    CONDITION="${(P)SEGMENT_CONDITION}"
  elif [[ -n "${10}" ]]; then
    CONDITION="${10}"
  else
    CONDITION='[[ -n "${8}" ]]'
  fi
  # Precompile condition.
  eval "${CONDITION}" && CONDITION=true || CONDITION=false

#  if ! ${CONDITION}; then
#    continue
#  fi

  "$3_prompt_segment" "${NAME}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${CONDITION}"
}

###############################################################
prompt_powerlevel9k_setup() {
  # Disable false display of command execution time
  [[ "$ARCH" == "x64" ]] && _P9K_TIMER_START=99999999999 || _P9K_TIMER_START=2147483647

  # Display a warning if the terminal does not support 256 colors
  local term_colors
  term_colors=$(echotc Co)
  if (( $term_colors < 256 )); then
    print -P "%F{red}WARNING!%f Your terminal appears to support less than 256 colors!"
    print -P "If your terminal supports 256 colors, please export the appropriate environment variable"
    print -P "_before_ loading this theme in your \~\/.zshrc. In most terminal emulators, putting"
    print -P "%F{blue}export TERM=\"xterm-256color\"%f at the top of your \~\/.zshrc is sufficient."
  fi

  # If the terminal `LANG` is set to `C`, this theme will not work at all.
  local term_lang
  term_lang=$(echo $LANG)
  if [[ $term_lang == 'C' ]]; then
      print -P "\t%F{red}WARNING!%f Your terminal's 'LANG' is set to 'C', which breaks this theme!"
      print -P "\t%F{red}WARNING!%f Please set your 'LANG' to a UTF-8 language, like 'en_US.UTF-8'"
      print -P "\t%F{red}WARNING!%f _before_ loading this theme in your \~\.zshrc. Putting"
      print -P "\t%F{red}WARNING!%f %F{blue}export LANG=\"en_US.UTF-8\"%f at the top of your \~\/.zshrc is sufficient."
  fi

  defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
  defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

  # Display a warning if deprecated segments are in use.
  typeset -AH deprecated_segments
  # old => new
  deprecated_segments=(
    'longstatus'        'status'
    'symfony2_version'  'symfony_version'
    'symfony2_tests'    'symfony_tests'
)
  print_deprecation_warning deprecated_segments

  setopt prompt_subst

  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  setopt PROMPT_CR PROMPT_PERCENT PROMPT_SUBST MULTIBYTE

  # initialize colors
  autoload -U colors && colors

  if segment_in_use "vcs"; then
    powerlevel9k_vcs_init
  fi

  # initialize timing functions
  zmodload zsh/datetime

  # Initialize math functions
  zmodload zsh/mathfunc

  # initialize hooks
  autoload -Uz add-zsh-hook

  # prepare prompts
  add-zsh-hook precmd powerlevel9k_prepare_prompts
  add-zsh-hook preexec powerlevel9k_preexec
}
