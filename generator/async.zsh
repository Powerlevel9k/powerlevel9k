#!/usr/env/bin zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
# ASYNC ENGINE

################################################################
# Prompt Segment Constructors
################################################################

###############################################################
# Begin a left prompt segment
# Takes nine arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: Bold: Boolean
#   * $6: The segment content
#   * $7: An identifying icon (must be a key of the icons array)
#   * $8: Last segments background color
#   * $9: Boolean - If the segment should be joined or not
# The latter three can be omitted,
set_default last_left_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
left_prompt_segment() {
  local current_index="${2}"
  local joined="${9}"

  local BACKGROUND_OF_LAST_SEGMENT="${8}"

  local bg fg bd
  [[ -n "${3}" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "${4}" ]] && fg="%F{$4}" || fg="%f"
  [[ ${(L)5} == "true" ]] && bd="%B" || bd=""

  if [[ "${BACKGROUND_OF_LAST_SEGMENT}" != 'NONE' ]] && ! isSameColor "${3}" "${BACKGROUND_OF_LAST_SEGMENT}"; then
    echo -n "${bg}%F{$BACKGROUND_OF_LAST_SEGMENT}"
    if [[ "${joined}" == "false" ]]; then
      # Middle segment
      echo -n "${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
    fi
  elif isSameColor "${BACKGROUND_OF_LAST_SEGMENT}" "${3}"; then
    # Middle segment with same color as previous segment
    # We take the current foreground color as color for our
    # subsegment (or the default color). This should have
    # enough contrast.
    local complement
    [[ -n "${4}" ]] && complement="${4}" || complement="${DEFAULT_COLOR}"
    echo -n "${bg}%F{$complement}"
    if [[ ${joined} == false ]]; then
      echo -n "${_POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
    fi
  else
    # First segment
    echo -n "${bg}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
  fi

  # Print the visual identifier
  echo -n "${7}"
  # Print the content of the segment
  echo -n "${fg}${bd}${6}%b${bg}${fg}"
  echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"

  BACKGROUND_OF_LAST_SEGMENT="${3}"
  last_left_element_index="${current_index}"
}

###############################################################
# End the left prompt, closes the final segment.
#   * $1: Last segments background color
left_prompt_end() {
  local BACKGROUND_OF_LAST_SEGMENT="${1}"
  if [[ -n "${BACKGROUND_OF_LAST_SEGMENT}" ]]; then
    echo -n "%k%F{$BACKGROUND_OF_LAST_SEGMENT}${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}"
  else
    echo -n "%k"
  fi
  echo -n "%f${_POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR}"
}

# Begin a right prompt segment
# Takes eight arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: Bold: Boolean
#   * $6: The segment content
#   * $7: An identifying icon (must be a key of the icons array)
#   * $8: Last segments background color
#   * $9: Boolean - If the segment should be joined or not
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default last_right_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  local current_index="${2}"
  local CURRENT_RIGHT_BG="${8}"
  local joined="${9}"

  local bg fg bd
  [[ -n "${3}" ]] && bg="%K{$3}" || bg="%k"
  [[ -n "${4}" ]] && fg="%F{$4}" || fg="%f"
  [[ ${(L)5} == "true" ]] && bd="%B" || bd=""

  # If CURRENT_RIGHT_BG is "NONE", we are the first right segment.
  if [[ "${joined}" == "false" ]] || [[ "${CURRENT_RIGHT_BG}" == "NONE" ]]; then
    if isSameColor "${CURRENT_RIGHT_BG}" "${3}"; then
      # Middle segment with same color as previous segment
      # We take the current foreground color as color for our
      # subsegment (or the default color). This should have
      # enough contrast.
      local complement
      [[ -n "${4}" ]] && complement="${4}" || complement=$DEFAULT_COLOR
      echo -n "%F{$complement}${_POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR}%f"
    else
      echo -n "%F{$3}${_POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR}%f"
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
    # Print segment content
    echo -n "${bd}${6}%b${bg}${fg}"
    # Print the visual identifier
    echo -n "${7}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"
  fi

  CURRENT_RIGHT_BG="${3}"
  last_right_element_index="${current_index}"
}

################################################################
# Caching functions
################################################################

###############################################################
# This function serializes a segment to disk under /tmp/p9k/
# When done with writing to disk, the function sends a
# signal to the parent process.
#
# Parameters:
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
serialize_segment() {
  local NAME="${1}"
  local STATE="${2}"
  local ALIGNMENT="${3}"
  local INDEX="${4}"
  local JOINED="${5}"
  local DURATION="$((EPOCHREALTIME - _P9K_SEGMENT_TIMER_START))"

  ################################################################
  # Methodology behind user-defined variables overwriting colors:
  #     The first parameter to the segment constructors is the calling function's
  #     name. From this function name, we strip the "prompt_"-prefix and
  #     uppercase it. This is then prefixed with "POWERLEVEL9K_" and suffixed
  #     with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
  #     name. So each new segment is user-overwritten by a variable following
  #     this naming convention.
  ################################################################

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
    CONDITION='[[ -n "${CONTENT}" ]]'
  fi
  # Precompile condition, as we are here in the async child process.
  eval "${CONDITION}" && CONDITION=true || CONDITION=false

  local FILE="${CACHE_DIR}/p9k_$$_${ALIGNMENT}_${(l:3::0:)INDEX}_${NAME}.sh"

  # From the manpage of typeset:
  #   If the -p option is given, parameters and values are printed in the form
  #   of a typeset command with an assignment, regardless of other flags and
  #   options.  Note that the -H flag on parameters is respected; no value
  #   will  be  shown  for  these parameters.
  # Redirection with `>!`. From the manpage: Same as >, except that the file
  #   is truncated to zero length if it exists, even if CLOBBER is unset.
  # If the file already exists, and a simple `>` redirection and CLOBBER
  # unset, ZSH will produce an error.
  typeset -p "NAME" >! $FILE
  typeset -p "STATE" >> $FILE
  typeset -p "ALIGNMENT" >> $FILE
  typeset -p "INDEX" >> $FILE
  typeset -p "JOINED" >> $FILE
  typeset -p "BACKGROUND" >> $FILE
  typeset -p "FOREGROUND" >> $FILE
  typeset -p "BOLD" >> $FILE
  typeset -p "CONTENT" >> $FILE
  typeset -p "VISUAL_IDENTIFIER" >> $FILE
  typeset -p "CONDITION" >> $FILE
  typeset -p "DURATION" >> $FILE

  # send WINCH signal to parent process
  kill -s WINCH $$
  # Block for long enough for the signal to come through
  sleep 1
}

###############################################################
# Rebuild prompt from cache every time
# a child process terminates (= sends
# SIGWINCH). We read in the segments
# variables, use that information to
# glue the segments back togeher and
# finally reset the prompt.
set_default CACHE_DIR /tmp/p9k
# Create cache dir
mkdir -p "${CACHE_DIR}" 2> /dev/null
#   $1 - Signal that should be propagated
p9k_build_prompt_from_cache() {
  # Set option so that prompt gets expanded
  # See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  setopt PROMPT_SUBST
  last_left_element_index=1 # Reset
  local LAST_LEFT_BACKGROUND='NONE' # Reset
  local LAST_RIGHT_BACKGROUND='NONE' # Reset
  PROMPT='' # Reset
  RPROMPT='' # Reset
  local RPROMPT_SUFFIX=''
  local PROMPT_SUFFIX=''
  if [[ "${POWERLEVEL9K_PROMPT_ON_NEWLINE}" == true ]]; then
    PROMPT="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k${PROMPT}"
    PROMPT_SUFFIX="
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    if [[ "${POWERLEVEL9K_RPROMPT_ON_NEWLINE}" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt. To do so, there is just a quite ugly workaround: Before zsh draws
      # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
      # advise it to go one line down. See:
      # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
      local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters
      RPROMPT='%{'$'\e[1A''%}' # one line up
      RPROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
    fi
  fi

  typeset -Ah last_segments_print_states
  last_segments_print_states=()
  typeset -Ah last_segments_join_states
  last_segments_join_states=()

  # (N) sets the NULL_GLOB option, so that if the glob does
  # not return files, an error message is suppressed.
  for cacheFile in ${CACHE_DIR}/p9k_$$_*(N); do
    source "${cacheFile}"

    local paddedIndex="${(l:3::0:)INDEX}"

    # Default: Segment should NOT be joined.
    local should_join_segment=false

    # If the current segment wants to be joined, we need
    # to have a close look at our predecessors.
    if [[ "${JOINED}" == "true" ]]; then
      # If we want to know if the current segment should be joined or
      # not, we need to consider the previous segments join state and
      # whether they were printed or not.
      # Beginning from our current position and moving to the left (as
      # this is the joining direction; segments can always be joined
      # with their predecessor, a.k.a. previous left segment). As soon
      # as we find a segment that was not joined and not printed, we
      # promote the segment to a full one.
      should_join_segment=true
      for ((n=${INDEX}; n > 0; n=${n}-1)); do
        # Little magic trick: We start from current index, although we
        # just want to examine our ancestors because the current
        # segment is not yet in the array. So we just skip one step
        # implicitly.
        local currentPaddedIndex="${(l:3::0:)n}"
        local print_state=$last_segments_print_states["${ALIGNMENT}_${currentPaddedIndex}"]
        local join_state=$last_segments_join_states["${ALIGNMENT}_${currentPaddedIndex}"]

        if [[ "${join_state}" == "false" && "${print_state}" == "false" ]]; then
          should_join_segment=false
          # Break the loop as early as possible. If we know that our segment should
          # be promoted, we got the relevant information we wanted.
          break
        elif [[ "${join_state}" == "true" && "${print_state}" == "true" ]]; then
          # If previous segment was joined and printed, we can break here
          # because this previous segment should handle its join state.
          break
        elif [[ "${join_state}" == "false" ]]; then
          break
        fi
      done
    fi

    last_segments_join_states["${ALIGNMENT}_${paddedIndex}"]="${JOINED}"
    last_segments_print_states["${ALIGNMENT}_${paddedIndex}"]="${CONDITION}"

    # If the segments condition to print was not met, skip it!
    if ! ${CONDITION}; then
      continue
    fi

    local statefulName="${NAME}"
    [[ -n "${STATE}" ]] && statefulName="${NAME}_${STATE}"

    if [[ "${ALIGNMENT}" == "left" ]]; then
      PROMPT+=$("${(L)ALIGNMENT}_prompt_segment" "${statefulName}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${LAST_LEFT_BACKGROUND}" "${should_join_segment}")
      LAST_LEFT_BACKGROUND="${BACKGROUND}"
    elif [[ "${ALIGNMENT}" == "right" ]]; then
      RPROMPT+=$("${(L)ALIGNMENT}_prompt_segment" "${statefulName}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${LAST_RIGHT_BACKGROUND}" "${should_join_segment}")
      LAST_RIGHT_BACKGROUND="${BACKGROUND}"
    fi
  done
  PROMPT+="$(left_prompt_end ${LAST_LEFT_BACKGROUND})"
  PROMPT+="${PROMPT_SUFFIX}"
  RPROMPT+="${RPROMPT_SUFFIX}"

  NEWLINE='
'
  [[ "${POWERLEVEL9K_PROMPT_ADD_NEWLINE}" == "true" ]] && PROMPT="${NEWLINE}${PROMPT}"

  # About .reset-promt see:
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  zle && zle .reset-prompt

  # Add zero to $1, so that we can call this function without parameters
  # in tests..
  return $(( 128 + ($1 + 0) ))
}
# Register trap on WINCH (Rebuild prompt)
trap "p9k_build_prompt_from_cache WINCH" WINCH

###############################################################
#   $1 - Signal that should be propagated
p9k_clear_cache() {
  # Stupid way to avoid "no matches found" globbing error on
  # deleting cache files.
  touch ${CACHE_DIR}/p9k_$$_dummy
  # (N) sets the NULL_GLOB option, so that if the glob does
  # not return files, an error message is suppressed.
  rm -f ${CACHE_DIR}/p9k_$$_*(N)

  # We also call this function from `powerlevel9k_prepare_prompt`
  # There we just want to clean the cache without having signal
  # to propagate. This is the reason, why we need the condition.
  if [[ -n "${1}" ]]; then
    return $(( 128 + $1 ))
  fi
}
# Register trap on EXIT (cleanup)
trap "p9k_clear_cache EXIT" EXIT
# Register trap on TERM (cleanup)
trap "p9k_clear_cache TERM" TERM

################################################################
# Prompt processing and drawing
################################################################

###############################################################
# Main prompt
build_left_prompt() {
  local index=1
  for element in "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"; do
    local joined=false
    [[ "${element[-7,-1]}" == '_joined' ]] && joined=true
    # Remove joined information in direct calls
    element="${element%_joined}"

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "left" "${index}" "${element[8,-1]}" "${joined}" &!
    else
      # Could we display placeholders?
      # -> At most it could be static ones, but
      # e.g. states are the result of calculation..
      "prompt_$element" "left" "${index}" "${joined}" &!
    fi

    index=$((index + 1))
  done
}

###############################################################
# Right prompt
build_right_prompt() {
  local index=1
  for element in "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; do
    local joined=false
    [[ "${element[-7,-1]}" == '_joined' ]] && joined=true
    # Remove joined information in direct calls
    element="${element%_joined}"

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "right" "$index" "${element[8,-1]}" "${joined}" &!
    else
      "prompt_$element" "right" "$index" "${joined}" &!
    fi

    index=$((index + 1))
  done
}

###############################################################
# This hook runs before the command runs.
powerlevel9k_preexec() {
  # The Timer is started here, but the end
  # is taken in powerlevel_prepare_prompts,
  # as this method is a precmd hook and runs
  # right before the prompt gets rendered. So
  # we can calculate the duration there.
  _P9K_TIMER_START=$EPOCHREALTIME
}

###############################################################
ASYNC_PROC=0
powerlevel9k_prepare_prompts() {
  RETVAL=$?

  # Kill all spawns that are not the main process!
  # This method gets called every time, because it
  # is a precmd hook registered in powerlevel9k_init!
  # The child processes must be killed, because they
  # should only be triggered once to build their
  # segment and nothing else.
  if [[ "${ASYNC_PROC}" != 0 ]]; then
    kill -s HUP ${ASYNC_PROC} >/dev/null 2>&1 || :
  fi

  # Timing calculation
  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))
  # Reset start time
  _P9K_TIMER_START=99999999999
  # Start segment timing
  _P9K_SEGMENT_TIMER_START="${EPOCHREALTIME}"

  # Ensure that every time the user wants a new prompt,
  # he gets a new, fresh one.
  p9k_clear_cache

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  build_left_prompt
  if [[ "${POWERLEVEL9K_DISABLE_RPROMPT}" != "true" ]]; then
    build_right_prompt
  fi

  ASYNC_PROC=$!
}

###############################################################
prompt_powerlevel9k_setup() {
  # Disable false display of command execution time
  _P9K_TIMER_START=99999999999

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

  # initialize colors
  autoload -U colors && colors

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
