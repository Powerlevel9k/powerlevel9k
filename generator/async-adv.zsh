#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
# ZSH ASYNC ENGINE

# Debugging
ASYNC_DEBUG=1

################################################################
# Prompt Segment Constructors
################################################################

###############################################################
# Build a left prompt segment
# @Parameters
#   * $1 Stateful name of the function that was originally invoked (mandatory).
#   * $2 The array index of the current segment
#   * $3 Background color
#   * $4 Foreground color
#   * $5 Bold: Boolean
#   * $6 The segment content
#   * $7 An identifying icon
left_prompt_segment() {
  POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
  local stateful_name="${1}" index="${2}" bg="%K{${3}}" fg="%F{${4}}" content="${6}" visual_identifier="${7}"
  # check if it should be bold
  [[ ${5} == "true" ]] && local bd="%B" || local bd=""
  # set the colors
  local segment="${bg}${fg}"
  # add the visual identifier
  segment+="${visual_identifier}${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"
  # add the content
  segment+="${fg}${bd}${content}%b${bg}${fg}"
  # return the result
  echo "${index}·|·${segment}"
}

###############################################################
# Build a rightt prompt segment
# @Parameters
#   * $1 Stateful name of the function that was originally invoked (mandatory).
#   * $2 The array index of the current segment
#   * $3 Background color
#   * $4 Foreground color
#   * $5 Bold: Boolean
#   * $6 The segment content
#   * $7 An identifying icon
right_prompt_segment() {
  POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=" "
  local stateful_name="${1}" index="${2}" bg="%K{${3}}" fg="%F{${4}}" content="${6}" visual_identifier="${7}"
  # check if it should be bold
  [[ ${5} == "true" ]] && local bd="%B" || local bd=""
  # set the colors
  local segment="${bg}${fg}"
  if [[ ${(L)POWERLEVEL9K_RPROMPT_ICON_LEFT} == "true" ]]; then
    # add the visual identifier
    segment+="${visual_identifier}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
    # add the content
    segment+="${bd}${content}%b${bg}${fg}"
  else
    # add the content
    segment+="${bd}${content}%b${bg}${fg}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"
    # add the visual identifier
    segment+="${visual_identifier}"
  fi
  # return the result
  echo "${index}·|·${segment}"
}

last_left_bg() {
  local current_index="${1}" last_bg=0
  for (( i = ${current_index} - 1; i > 0; i-- )); do
    if [[ ${POWERLEVEL9K_LEFT_PROMPT[$i]} != "" ]]; then
      local last_bg="${POWERLEVEL9K_LEFT_PROMPT_BG_COLORS[$i]}"
      break
    fi
  done
  echo "$last_bg"
}

last_right_bg() {
  local current_index="${1}" last_bg=0
  for (( i = ${current_index} - 1; i > 0; i-- )); do
    if [[ ${POWERLEVEL9K_RIGHT_PROMPT[$i]} != "" ]]; then
      local last_bg="${POWERLEVEL9K_RIGHT_PROMPT_BG_COLORS[$i]}"
      break
    fi
  done
  echo "$last_bg"
}

################################################################
# Async functions
################################################################

p9k_async_callback() {
  setopt localoptions noshwordsplit
  local job=$1 code=$2 output=$3 exec_time=$4
  case $job in
    p9k_serialize_segment)
      if [[ -n $output ]]; then
        # split $output into an array - see https://unix.stackexchange.com/a/28873
        local ar=("${(@s:·|·:)output}") # split on delimiter "·|·"
        local NAME=${ar[1]} STATE=${ar[2]} ALIGNMENT=${ar[3]} INDEX=${ar[4]} JOINED=${ar[5]} BACKGROUND=${ar[6]} FOREGROUND=${ar[7]} BOLD=${ar[8]} CONTENT=${ar[9]} VISUAL_IDENTIFIER=${ar[10]} CONDITION=${ar[11]}
        unset ar

        # If the segments condition to print was met, add it!
        if [[ ${(L)CONDITION} == "true" ]]; then
          local STATEFUL_NAME="${(U)NAME#prompt_}"
          [[ -n "${STATE}" ]] && STATEFUL_NAME="${STATEFUL_NAME}_${(U)STATE}"

          if [[ "${(L)ALIGNMENT}" == "left" ]]; then
            POWERLEVEL9K_LEFT_PROMPT_BG_COLORS[$INDEX]="${BACKGROUND}"
            POWERLEVEL9K_LEFT_PROMPT_FG_COLORS[$INDEX]="${FOREGROUND}"
            async_job "p9k" left_prompt_segment "${STATEFUL_NAME}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${JOINED}"
          else
            POWERLEVEL9K_RIGHT_PROMPT_BG_COLORS[$INDEX]="${BACKGROUND}"
            POWERLEVEL9K_RIGHT_PROMPT_FG_COLORS[$INDEX]="${FOREGROUND}"
            async_job "p9k" right_prompt_segment "${STATEFUL_NAME}" "${INDEX}" "${BACKGROUND}" "${FOREGROUND}" "${BOLD}" "${CONTENT}" "${VISUAL_IDENTIFIER}" "${JOINED}"
          fi
        else
          if [[ "${(L)ALIGNMENT}" == "left" ]]; then
            POWERLEVEL9K_LEFT_PROMPT[${INDEX}]=""
          else
            POWERLEVEL9K_RIGHT_PROMPT[${INDEX}]=""
          fi
        fi
      fi
    ;;
    left_prompt_segment)
      if [[ -n $output ]]; then
        setopt PROMPT_SUBST
        local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters

        # split $output into an array - see https://unix.stackexchange.com/a/28873
        #local ar=("${(@f)output}") # split on newline
        local ar=("${(@s:·|·:)output}") # split on delimiter "·|·"
        # store the segment
        POWERLEVEL9K_LEFT_PROMPT[${ar[1]}]="${ar[2]}"

        local fg bg last_bg segments
        segments=${#POWERLEVEL9K_LEFT_PROMPT}
        # configure the prompts
        left_prompt="$left_prompt_prefix"
        for (( i = 1; i <= ${segments}; i++ )); do
          if [[ -n ${POWERLEVEL9K_LEFT_PROMPT[$i]} ]]; then
            fg=${POWERLEVEL9K_LEFT_PROMPT_FG_COLORS[$i]}
            bg=${POWERLEVEL9K_LEFT_PROMPT_BG_COLORS[$i]}
            if [[ $i != 1 ]]; then
              # find previous background
              last_bg=$(last_left_bg $i)
              left_prompt+="%K{${bg}}%F{${last_bg}}${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR} "
            else
              left_prompt="%K{${bg}} ${left_prompt}"
            fi
            left_prompt+="${POWERLEVEL9K_LEFT_PROMPT[$i]} "
          fi
        done
        bg=$(last_left_bg ${#POWERLEVEL9K_LEFT_PROMPT})
        left_prompt+="%F{${bg}}%k${_POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR}%f%b $left_prompt_suffix"
        PROMPT=${left_prompt}
        # About .reset-prompt see:
        # https://github.com/sorin-ionescu/prezto/issues/1026
        # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
        zle && zle .reset-prompt
      fi
    ;;
    right_prompt_segment)
      if [[ -n $output ]]; then
        setopt PROMPT_SUBST
        local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters

        # split $output into an array - see https://unix.stackexchange.com/a/28873
        #local ar=("${(@f)output}") # split on newline
        local ar=("${(@s:·|·:)output}") # split on delimiter "·|·"
        # store the segment
        POWERLEVEL9K_RIGHT_PROMPT[${ar[1]}]="${ar[2]}"

        local fg bg last_bg segments
        segments=${#POWERLEVEL9K_RIGHT_PROMPT}
        right_prompt="$right_prompt_prefix"
        for (( i = 1; i <= ${segments}; i++ )); do
          if [[ -n ${POWERLEVEL9K_RIGHT_PROMPT[$i]} ]]; then
            fg=${POWERLEVEL9K_RIGHT_PROMPT_FG_COLORS[$i]}
            bg=${POWERLEVEL9K_RIGHT_PROMPT_BG_COLORS[$i]}
            # find previous background
            last_bg=$(last_right_bg $i)
            right_prompt+="%K{${last_bg}}%F{${bg}}${_POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR}"
            right_prompt+="${POWERLEVEL9K_RIGHT_PROMPT[$i]} "
          fi
        done
        right_prompt+="$right_prompt_suffix"
        RPROMPT=${right_prompt}
        # About .reset-prompt see:
        # https://github.com/sorin-ionescu/prezto/issues/1026
        # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
        zle && zle .reset-prompt
      fi
    ;;
  esac
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
p9k_serialize_segment() {
  local NAME="${1}" STATE="${2}" ALIGNMENT="${3}" INDEX="${4}" JOINED="${(L)5}"
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
  [[ -z "${BOLD}" ]] && BOLD="false" || BOLD="true"

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

  echo "$NAME·|·$STATE·|·$ALIGNMENT·|·$INDEX·|·$JOINED·|·$BACKGROUND·|·$FOREGROUND·|·$BOLD·|·$CONTENT·|·$VISUAL_IDENTIFIER·|·$CONDITION"
  [[ $CONDITION == "true" ]] && return 1 || return 0
}

serialize_segment() {
  async_job "p9k" p9k_serialize_segment "${@}"
}

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

prompt_setup() {
  PROMPT=""
  RPROMPT=""
  left_prompt_prefix=""
  left_prompt_suffix=""
  right_prompt_prefix=""
  right_prompt_suffix=""

  setopt PROMPT_SUBST
  local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters

  # preset multiline prompt
  if [[ "${POWERLEVEL9K_PROMPT_ON_NEWLINE}" == true ]]; then
    left_prompt_prefix="$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k${PROMPT}"
    left_prompt_suffix="
$(print_icon 'MULTILINE_SECOND_PROMPT_PREFIX')"
    if [[ "${POWERLEVEL9K_RPROMPT_ON_NEWLINE}" != true ]]; then
      # The right prompt should be on the same line as the first line of the left
      # prompt. To do so, there is just a quite ugly workaround: Before zsh draws
      # the RPROMPT, we advise it, to go one line up. At the end of RPROMPT, we
      # advise it to go one line down. See:
      # http://superuser.com/questions/357107/zsh-right-justify-in-ps1
      right_prompt_prefix='%{'$'\e[1A''%}' # one line up
      right_prompt_suffix='%{'$'\e[1B''%}' # one line down
    fi
  fi
}

###############################################################
# This hook runs before the command runs.
powerlevel9k_preexec() {
  # The Timer is started here, but the end
  # is taken in powerlevel_prepare_prompts,
  # as this method is a precmd hook and runs
  # right before the prompt gets rendered. So
  # we can calculate the duration there.
  _P9K_TIMER_START=${EPOCHREALTIME}
}

###############################################################
powerlevel9k_prepare_prompts() {
  setopt localoptions noshwordsplit

  # stop any running async jobs
  async_flush_jobs "p9k"

  declare -A POWERLEVEL9K_LEFT_PROMPT
  declare -A POWERLEVEL9K_RIGHT_PROMPT

  # Timing calculation
  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))
  # Reset start time - Maximum integer on 32-bit CPUs
  [[ "$ARCH" == "x64" ]] && _P9K_TIMER_START=99999999999 || _P9K_TIMER_START=2147483647
  # I decided to use the value above for better supporting 32-bit CPUs, since the previous value "99999999999" was
  # causing issues on my Android phone, which is powered by an armv7l
  # We don't have to change that until 19 January of 2038! :)

  # Start segment timing
  _P9K_SEGMENT_TIMER_START="${EPOCHREALTIME}"

  # Initialize icon overrides
  _powerlevel9kInitializeIconOverrides

  # Initialize the prompts
  prompt_setup

  # Precompile the Segment Separators here!
  _POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')"
  _POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR="$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="$(print_icon 'RIGHT_SEGMENT_SEPARATOR')"
  _POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')"

  build_left_prompt
  if [[ "${(L)POWERLEVEL9K_DISABLE_RPROMPT}" != "true" ]]; then
    build_right_prompt
  fi
}

###############################################################
prompt_powerlevel9k_setup() {
  # Disable false display of command execution time
  [[ "$ARCH" == "x64" ]] && _P9K_TIMER_START=99999999999 || _P9K_TIMER_START=2147483647

  prompt_opts=(subst percent)
  # borrowed from promptinit, sets the prompt options in case pure was not
  # initialized via promptinit.
  setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

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

  # initialize hooks
  autoload -Uz add-zsh-hook

  # initialize zsh async
  #autoload -Uz async && async
  source $script_location/zsh-async/async.zsh

  # initialize async worker
  (( !${p9k_async_init:-0} )) && {
    async_start_worker "p9k" -n
    async_register_callback "p9k" p9k_async_callback
    p9k_async_init=1
  }

  # initialize timing functions
  zmodload zsh/datetime

  # Initialize math functions
  zmodload zsh/mathfunc

  # prepare prompts
  add-zsh-hook precmd powerlevel9k_prepare_prompts
  add-zsh-hook preexec powerlevel9k_preexec
}
