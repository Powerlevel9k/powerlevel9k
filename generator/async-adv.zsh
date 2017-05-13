#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Async Engine
# @source https://github.com/bhilburn/powerlevel9k
##
# @authors
#   Ben Hilburn (bhilburn)
#   Dominic Ritter (dritter)
#   Christo Kotze (onaforeignshore)
##
# @dependency
#   [zsh-async](https://github.com/mafredri/zsh-async)
##
# @info
#   This file contains an async generator for the powerlevel9k
#   project. It makes use of zsh-async in order to build the
#   prompts asynchronously.
##

# Debugging
#ASYNC_DEBUG=1

################################################################
# Prompt Segment Constructors
################################################################

###############################################################
# @description
#   Spawn a subshell to convert the data into a left prompt segment
##
# @arg
#   $1 string Name - The stateful name of the function that was originally invoked (mandatory).
#   $2 integer Index - Segment array index
#   $3 string Background - Segment background color
#   $4 string Foreground - Segment foreground color
#   $5 boolean Bold - Whether the segment should be bold
#   $6 string Content - Segment content
#   $7 string Visual Identifier - Segment icon
##
POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=" "
left_prompt_segment() {
  # Name the parameters and add %K and %F to color variables
  local STATEFUL_NAME="${1}" INDEX="${2}" BG="%K{${3}}" FG="%F{${4}}" BOLD="${5}" CONTENT="${6}" VISUAL_IDENTIFIER="${7}"
  # Check if it should be bold
  [[ ${BOLD} == "true" ]] && local BD="%B" || local BD=""
  # Set the colors
  local SEGMENT="${BG}${FG}"
  # Add the visual identifier if it exists
  [[ -n ${VISUAL_IDENTIFIER} ]] && SEGMENT+="${VISUAL_IDENTIFIER}"
  # Add the content
  if [[ -n ${CONTENT} ]]; then
    [[ -n ${VISUAL_IDENTIFIER} ]] && SEGMENT+="${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
    [[ -n "${BD}" ]] && SEGMENT+="${BD}${CONTENT}%b" || SEGMENT+="${CONTENT}"
  fi
  # Return the result to the main process, delimited by "·|·"
  [[ "${INDEX}" != "" ]] && echo "${INDEX}·|·${SEGMENT}"
}

###############################################################
# @description
#   Spawn a subshell to convert the data into a right prompt segment
##
# @arg
#   $1 string Name - The stateful name of the function that was originally invoked (mandatory).
#   $2 integer Index - Segment array index
#   $3 string Background - Segment background color
#   $4 string Foreground - Segment foreground color
#   $5 boolean Bold - Whether the segment should be bold
#   $6 string Content - Segment content
#   $7 string Visual Identifier - Segment icon
##
POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=" "
right_prompt_segment() {
  # Name the parameters and add %K and %F to color variables
  local STATEFUL_NAME="${1}" INDEX="${2}" BG="%K{${3}}" FG="%F{${4}}" CONTENT="${6}" VISUAL_IDENTIFIER="${7}"
  # Check if it should be bold
  [[ ${BOLD} == "true" ]] && local BD="%B" || local BD=""
  # Set the colors
  local SEGMENT="${BG}${FG}"
  if [[ ${(L)POWERLEVEL9K_RPROMPT_ICON_LEFT} == "true" ]]; then # Visual identifier before content
    # Add the visual identifier if it exists
    [[ -n ${VISUAL_IDENTIFIER} ]] && SEGMENT+="${VISUAL_IDENTIFIER}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
    # Add the content
    [[ -n "${BD}" ]] && SEGMENT+="${BD}${CONTENT}%b" || SEGMENT+="${CONTENT}"
  else # Content before visual identifier
    # Add the content
    SEGMENT+="${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
      [[ -n "${BD}" ]] && SEGMENT+="${BD}${CONTENT}%b${BG}${FG}" || SEGMENT+="${CONTENT}"
    # Add the visual identifier if it exists
    [[ -n ${VISUAL_IDENTIFIER} ]] && SEGMENT+="${VISUAL_IDENTIFIER}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
  fi
  # Return the result to the main process, delimited by "·|·"
  [[ "${INDEX}" != "" ]] && echo "${INDEX}·|·${SEGMENT}"
}

###############################################################
# @description
#   This function determines the background of the previous VISIBLE segment in the left prompt.
##
# @arg
#   $1 integer Index - Left prompt source segment index
##
last_left_bg() {
  # Name the parameters
  local CURRENT_INDEX="${1}" LAST_BG=0
  # Start at the segment before the current segment and work to the left
  for (( i = ${CURRENT_INDEX} - 1; i > 0; i-- )); do
    # If the segment is not empty, we have our color
    if [[ ${P9K_LP_CONTENT[$i]} != "·" ]]; then
      local LAST_BG="${P9K_LP_BACKGROUND[$i]}"
      break
    fi
  done
  echo "$LAST_BG"
}

###############################################################
# @description
#   This function determines the background of the previous VISIBLE segment in the right prompt.
##
# @arg
#   $1 integer Index - Right prompt source segment index
##
last_right_bg() {
  # Name the parameters
  local CURRENT_INDEX="${1}" LAST_BG=0
  # Start at the segment before the current segment and work to the left
  for (( i = ${CURRENT_INDEX} - 1; i > 0; i-- )); do
    # If the segment is not empty, we have our color
    if [[ ${P9K_RP_CONTENT[$i]} != "·" ]]; then
      local LAST_BG="${P9K_RP_BACKGROUND[$i]}"
      break
    fi
  done
  echo "$LAST_BG"
}

update_left_prompt() {
  local LBG LAST_LBG LSEGMENTS
  # Determine how many segments are visible in the left prompt
  LSEGMENTS=${#P9K_LP_CONTENT}
  # Build the left prompt string
  LEFT_PROMPT=""
  for (( i = 1; i <= ${LSEGMENTS}; i++ )); do
    if [[ "${P9K_LP_CONTENT[$i]}" != "·" ]]; then
      LBG=${P9K_LP_BACKGROUND[$i]}
      LFG=${P9K_LP_FOREGROUND[$i]}
      if [[ $i != 1 ]]; then # If it is not the first segment...
        # Find previous left segment background
        LAST_LBG=$(last_left_bg $i)
        if [[ $P9K_LP_JOINED[$i] == "true" ]]; then # If the segment are joined...
          if  [[ "${LBG}" == "${LAST_LBG}" ]]; then # Are the backgrounds the same...
            # We take the current foreground color as color for our subsegment, and
            # add a left sub segment separator. This should have enough contrast.
            LEFT_PROMPT+="%K{${LBG}}%F{${LFG}}${_POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR} "
          fi
        else # ...not joined
          # Add a left segment separator
          LEFT_PROMPT+="%K{${LBG}}%F{${LAST_LBG}}${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR} "
        fi
      else # ...otherwise it is the first segment and there is no previous background
        [[ "${POWERLEVEL9K_FANCY_EDGE}" == "true" ]] && LEFT_PROMPT+="%F{${LBG}}${_POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR}"
        LEFT_PROMPT+="%K{${LBG}} "
      fi
      # Add the segment to the left prompt string
      LEFT_PROMPT+="${P9K_LP_CONTENT[$i]} "
    fi
  done
  # Prompt is complete, so find the background of the last segment
  local LBI=$((${#P9K_LP_CONTENT} + 1))
  LBG=$(last_left_bg ${LBI})
  # Add the last left segment separator and the suffix
  LEFT_PROMPT+="%F{${LBG}}%k${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}%f%b "
  # Set the left prompt
  PROMPT=${LEFT_PROMPT_PREFIX}${LEFT_PROMPT}${LEFT_PROMPT_SUFFIX}
  # About .reset-prompt see:
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  zle .reset-prompt
}

update_right_prompt() {
  local RBG LAST_RBG RSEGMENTS
  # Determine how many segments are visible in the left prompt
  RSEGMENTS=${#P9K_RP_CONTENT}
  # Build the left prompt string
  RIGHT_PROMPT=""
  for (( i = 1; i <= ${RSEGMENTS}; i++ )); do
    if [[ "${P9K_RP_CONTENT[$i]}" != "·" ]]; then
      RBG=${P9K_RP_BACKGROUND[$i]}
      RFG=${P9K_RP_FOREGROUND[$i]}
      # Find previous right segment background
      LAST_RBG=$(last_right_bg $i)
      # Should the segment be joined?
      if [[ $P9K_RP_JOINED[$i] == "true" ]]; then
        # Are the backgrounds the same...
        if [[ "${RBG}" == "${LAST_RBG}" ]]; then
          # We take the current foreground color as color for our subsegment,
          # and add a sub segment separator. This should have enough contrast.
          RIGHT_PROMPT+="%K{${RBG}}%F{${RFG}}${_POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR}"
        fi
      else
        # ...otherwise add a right segment separator
        RIGHT_PROMPT+="%K{${LAST_RBG}}%F{${RBG}}${_POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR}"
      fi
      # Add the segment to the right prompt string
      RIGHT_PROMPT+="${P9K_RP_CONTENT[$i]} "
    fi
  done
  [[ "${POWERLEVEL9K_FANCY_EDGE}" == "true" ]] && RIGHT_PROMPT+="%k%F{$RBG}${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}%f"
  # Set the left prompt
  RPROMPT=${RIGHT_PROMPT_PREFIX}${RIGHT_PROMPT}${RIGHT_PROMPT_SUFFIX}
  # About .reset-prompt see:
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  zle .reset-prompt
}

################################################################
# Async functions
################################################################

###############################################################
# @description
#   This function is the heart of the async engine. Whenever a
#   subshell is completed, this function is called to deal with
#   the generated output.
##
# @arg
#   $1 string Job - The name of the calling function or job
#   $2 number Code - Return code (If the value is -1, then it is likely that there is a bug)
#   $3 string Output - Resulting (stdout) output from the job
#   $4 number Exec_Time - Execution time, floating point (in seconds)
#   $5 string Err - Resulting (stderr) output from the job
##
p9k_async_callback() {
  # Name the parameters (CODE, EXEC_TIME and ERR are not currently used, but are included for possible future use)
  local JOB="${1}" CODE="${2}" OUTPUT="${3}" EXEC_TIME="${4}" ERR="${5}"

  # Determine which function returned output...
  case $JOB in
    p9k_serialize_segment) # Segment code was converted into data
      # Make sure we received the data
      if [[ -n $OUTPUT ]]; then
        # split $OUTPUT into an array - see https://unix.stackexchange.com/a/28873
        #local ar=("${(@f)OUTPUT}") # split on newline (@f)
        local ar=("${(@s:·|·:)OUTPUT}") # split on delimiter "·|·" (@s:<delim>:)
        # Name the parameters
        local STATEFUL_NAME=${ar[1]} ALIGNMENT=${(L)ar[2]} INDEX=${ar[3]} JOINED=${ar[4]} BACKGROUND=${ar[5]} FOREGROUND=${ar[6]} BOLD=${ar[7]} CONTENT=${ar[8]} VISUAL_IDENTIFIER=${ar[9]} CONDITION=${ar[10]}

        # If $INDEX is not a number, then don't process the output
        # See: https://www.zsh.org/mla/users/2007/msg00086.html
        [[ ${INDEX} != <-> ]] && break

        # Conditions have three layers:
        # 1. No segment should print if they provide no content (default condition).
        # 2. Segments can define a default condition on their own, overriding the previous one.
        # 3. Users can set a condition for each segment. This is the trump card, and has highest precedence.
        local SEGMENT_CONDITION="POWERLEVEL9K_${STATEFUL_NAME}_CONDITION"
        if defined "${SEGMENT_CONDITION}"; then
          CONDITION="${(P)SEGMENT_CONDITION}"
        elif [[ -n "${CONDITION}" && "$CONDITION[0,1]" == "[" ]]; then
          CONDITION="${CONDITION}"
        else
          CONDITION='[[ -n "${CONTENT}" ]]'
        fi
        # Compile the condition to determine if we should process this segment or not.
        eval "${CONDITION}" && CONDITION=true || CONDITION=false

        if [[ ${CONDITION} == true ]]; then # If the segments condition to print was met, add it...
          if [[ "${ALIGNMENT}" == "left" ]]; then # If it is a left prompt segment...
            # Store the background, foreground and joined states in separate arrays
            P9K_LP_BACKGROUND[$INDEX]="${BACKGROUND}"
            P9K_LP_FOREGROUND[$INDEX]="${FOREGROUND}"
            P9K_LP_JOINED[$INDEX]="${JOINED}"
            # Send the data to a subshell to be converted into a left prompt segment
            async_job "p9k" left_prompt_segment "${STATEFUL_NAME}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}"
          else # ...it is a right prompt segment
            # Store the background, foreground and joined states in separate arrays
            P9K_RP_BACKGROUND[$INDEX]="${BACKGROUND}"
            P9K_RP_FOREGROUND[$INDEX]="${FOREGROUND}"
            P9K_RP_JOINED[$INDEX]="${JOINED}"
            # Send the data to a subshell to be converted into a left prompt segment
            async_job "p9k" right_prompt_segment "${STATEFUL_NAME}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}"
          fi
        else # ...otherwise set the prompt content array to "·" (no segemnt)
          [[ "${ALIGNMENT}" == "left" ]] && P9K_LP_CONTENT[${INDEX}]="·" || P9K_RP_CONTENT[${INDEX}]="·"
        fi
      fi
    ;;
    left_prompt_segment) # Data was converted into a left prompt segment
      # Make sure we received the segment data
      if [[ -n $OUTPUT ]]; then
        # Split $OUTPUT into an array - see https://unix.stackexchange.com/a/28873
        local ar=("${(@s:·|·:)OUTPUT}") # split on delimiter "·|·"

        # If $ar[1] (the index) is a number, then store the segment in the left prompt contents array
        # See: https://www.zsh.org/mla/users/2007/msg00086.html
        [[ ${ar[1]} == <-> ]] && P9K_LP_CONTENT[${ar[1]}]="${ar[2]}"
        # Update the left prompt
        update_left_prompt
      fi
    ;;
    right_prompt_segment) # Data was converted into a right prompt segment
      # Make sure we received the segment data
      if [[ -n $OUTPUT ]]; then
        # Split $OUTPUT into an array - see https://unix.stackexchange.com/a/28873
        #local ar=("${(@f)output}") # split on newline
        local ar=("${(@s:·|·:)OUTPUT}") # split on delimiter "·|·"

        # If $ar[1] (the index) is a number, then store the segment in the right prompt contents array
        # See: https://www.zsh.org/mla/users/2007/msg00086.html
        [[ ${ar[1]} == <-> ]] && P9K_RP_CONTENT[${ar[1]}]="${ar[2]}"
        # Update the right prompt
        update_right_prompt
      fi
    ;;
  esac
}

################################################################
# Caching functions
################################################################

###############################################################
# @description
#   This function processes the segment code in a subshell.
#   When done, the resulting data is sent to `p9k_async_callback`.
##
# @arg
#   $1 string Name - Segment name
#   $2 string State - Segment state
#   $3 string Alignment - left|right
#   $4 integer Index - Segment array index
#   $5 boolean Joined - If the segment should be joined
#   $6 string Background - Segment background color
#   $7 string Foreground - Segment foreground color
#   $8 string Content - Segment content
#   $9 string Visual identifier - Segment icon
#   $10 string Condition - The condition, if the segment should be printed (gets evaluated)
##
p9k_serialize_segment() {
  local NAME="${(U)1}" STATE="${(U)2}" ALIGNMENT="${3}" INDEX="${4}" JOINED="${5}" CONTENT="${8}" CONDITION="${10}"

  ################################################################
  # Methodology behind user-defined variables overwriting colors:
  #
  # The first parameter to the segment constructors is the calling function's
  # name. From this function name, we strip the "prompt_"-prefix and
  # uppercase it. This is then prefixed with "POWERLEVEL9K_" and suffixed
  # with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
  # name. So each new segment is user-overwritten by a variable following
  # this naming convention.
  ##

  # Determine the stateful name of the segment
  local STATEFUL_NAME="${NAME#PROMPT_}"
  [[ -n "${STATE}" ]] && STATEFUL_NAME="${STATEFUL_NAME}_${STATE}"

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
  [[ -z "${BOLD}" ]] && BOLD="false" || BOLD="true"

  # Precompile the Visual Identifier with color and spacing
  local VISUAL_IDENTIFIER
  if [[ -n "${9}" ]]; then
    VISUAL_IDENTIFIER="$(print_icon ${9})"
    if [[ -n "${VISUAL_IDENTIFIER}" ]]; then
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable="POWERLEVEL9K_${STATEFUL_NAME}_VISUAL_IDENTIFIER_COLOR"
      local visual_identifier_color="${(P)visual_identifier_color_variable}"
      # only add color to icon if override color is set and not equal to foreground
      if [[ -n "${visual_identifier_color}" && "${visual_identifier_color}" != "${FOREGROUND}" ]]; then
        VISUAL_IDENTIFIER="%F{${visual_identifier_color}}${VISUAL_IDENTIFIER}%F{${FOREGROUND}}"
      fi
      # Add an whitespace if we print more than just the visual identifier
      if [[ -n "${CONTENT}" ]]; then
        [[ "${POWERLEVEL9K_RPROMPT_ICON_LEFT}" ]] && VISUAL_IDENTIFIER="${VISUAL_IDENTIFIER} " ||
        [[ "${ALIGNMENT}" == "right" ]] && VISUAL_IDENTIFIER=" ${VISUAL_IDENTIFIER}"
      fi
    fi
  fi
  # Return the data to the main process, delimited with "·|·"
  echo "$STATEFUL_NAME·|·$ALIGNMENT·|·$INDEX·|·$JOINED·|·$BACKGROUND·|·$FOREGROUND·|·$BOLD·|·$CONTENT·|·$VISUAL_IDENTIFIER·|·$CONDITION"
}

###############################################################
# @description
#   This function is a wrapper function that starts off the async
#   process and passes the parameters from the segment code to the
#   subshells.
##
# @arg
#   $@ misc The parameters passed from the segment code
##
serialize_segment() {
  async_job "p9k" "p9k_serialize_segment" "${@}"
}

################################################################
# Prompt processing and drawing
################################################################

###############################################################
# @description
#   This function loops through the left prompt elements and calls
#   the related segment functions.
##
# @noarg
##
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
      [[ $element != "vi_mode" ]] && "prompt_$element" "left" "${index}" "${joined}" &!
    fi
    index=$((index + 1))
  done
}

###############################################################
# @description
#   This function loops through the right prompt elements and calls
#   the related segment functions.
##
# @noarg
##
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
      [[ $element != "vi_mode" ]] && "prompt_$element" "right" "$index" "${joined}" &!
    fi
    index=$((index + 1))
  done
}

###############################################################
# @description
#   This function is a hook that runs before the command runs.
#   It sets the start timer.
##
# @noarg
##
powerlevel9k_preexec() {
  # The Timer is started here, but the end
  # is taken in powerlevel_prepare_prompts,
  # as this method is a precmd hook and runs
  # right before the prompt gets rendered. So
  # we can calculate the duration there.
  _P9K_TIMER_START=${EPOCHREALTIME}
}

###############################################################
# @description
#   This function is a hook that is run before the prompts are created.
#   If sets all the required variables for the prompts and then
#   calls the prompt segment building functions.
##
# @noarg
##
powerlevel9k_prepare_prompts() {
  setopt localoptions noshwordsplit

  # stop any running async jobs
  async_flush_jobs "p9k"

  # Arrays to hold the left and right prompt segment data
  if [[ ${#P9K_LP_CONTENT} -ne ${#P9K_LP_ELEMENTS} ]]; then
    P9K_LP_CONTENT=()
    P9K_LP_BACKGROUND=()
    P9K_LP_FOREGROUND=()
    P9K_LP_JOINED=()
  fi
  if [[ ${#P9K_RP_CONTENT} -ne ${#P9K_RP_ELEMENTS} ]]; then
    P9K_RP_CONTENT=()
    P9K_RP_BACKGROUND=()
    P9K_RP_FOREGROUND=()
    P9K_RP_JOINED=()
  fi

  # Timing calculation
  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))
  # Reset start time - Maximum integer on 32-bit CPUs
  [[ "$ARCH" == "x64" ]] && _P9K_TIMER_START=99999999999 || _P9K_TIMER_START=2147483647
  # I decided to use the value above for better supporting 32-bit CPUs, since the previous value "99999999999" was
  # causing issues on my Android phone, which is powered by an armv7l
  # We don't have to change that until 19 January of 2038! :)

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Reset the prompts
  PROMPT=""
  RPROMPT=""
  LEFT_PROMPT_PREFIX=""
  LEFT_PROMPT_SUFFIX=""
  RIGHT_PROMPT_PREFIX=""
  RIGHT_PROMPT_SUFFIX=""

  # The prompt function will set these prompt_* options after the setup function
  # returns. We need prompt_subst so we can safely run commands in the prompt
  # without them being double expanded and we need prompt_percent to expand the
  # common percent escape sequences.
  prompt_opts=(cr percent subst)

  # Borrowed from promptinit, sets the prompt options in case the theme was
  # not initialized via promptinit.
  setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

  local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters

  # Preset multiline prompt
  if [[ "${POWERLEVEL9K_PROMPT_ON_NEWLINE}" == true ]]; then
    LEFT_PROMPT_PREFIX="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k${PROMPT}"
    LEFT_PROMPT_SUFFIX="
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    if [[ "${POWERLEVEL9K_RPROMPT_ON_NEWLINE}" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt. To do so, there is just a quite ugly workaround: Before zsh draws
      # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
      # advise it to go one line down. See:
      # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
      RIGHT_PROMPT_PREFIX='%{'$'\e[1A''%}' # one line up
      RIGHT_PROMPT_SUFFIX='%{'$'\e[1B''%}' # one line down
    fi
  fi

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  # Call the prompt building functions
  build_left_prompt
  if [[ "${(L)POWERLEVEL9K_DISABLE_RPROMPT}" != "true" ]]; then
    build_right_prompt
  fi
}

p9k_chpwd() {
  powerlevel9k_prepare_prompts
  powerlevel9k_preexec
}

###############################################################
# @description
#   This is the main function. It does the necessary checks,
#   loads the required resources and sets the required hooks.
##
# @noarg
##
prompt_powerlevel9k_setup() {
  # Disable false display of command execution time
  [[ "$ARCH" == "x64" ]] && _P9K_TIMER_START=99999999999 || _P9K_TIMER_START=2147483647

  #prompt_opts=(cr subst percent)
  # borrowed from promptinit, sets the prompt options in case pure was not
  # initialized via promptinit.
  #setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

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

  defined P9K_LP_ELEMENTS || P9K_LP_ELEMENTS=(context dir rbenv vcs)
  defined P9K_RP_ELEMENTS || P9K_RP_ELEMENTS=(status root_indicator background_jobs history time)

  # Display a warning if deprecated segments are in use.
  typeset -AH deprecated_segments
  # old => new
  deprecated_segments=(
    'longstatus'        'status'
    'symfony2_version'  'symfony_version'
    'symfony2_tests'    'symfony_tests'
  )
  print_deprecation_warning deprecated_segments

  # initialize prompt arrays
  declare -A P9K_LP_CONTENT
  declare -A P9K_RP_CONTENT

  # initialize colors
  autoload -U colors && colors

  # initialize hooks
  autoload -Uz add-zsh-hook

  # initialize zsh async
  #autoload -Uz async && async
  source $script_location/zsh-async/async.zsh

  # initialize async worker
  (( !${p9k_async_init:-0} )) && {
    async_start_worker "p9k" -n
    async_register_callback "p9k" "p9k_async_callback"
    p9k_async_init=1
  }

  # initialize timing functions
  zmodload zsh/datetime

  # Initialize math functions
  zmodload zsh/mathfunc

  # prepare prompts
  add-zsh-hook precmd powerlevel9k_prepare_prompts
  add-zsh-hook preexec powerlevel9k_preexec

  # initialize zle
  zle

  # hook into chpwd for bindkey support
  chpwd_functions=(${chpwd_functions[@]} "p9k_chpwd")
}
