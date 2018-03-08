# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# powerlevel9k Theme
# https://github.com/bhilburn/powerlevel9k
#
# This theme was inspired by agnoster's Theme:
# https://gist.github.com/3712874
################################################################

################################################################
# For basic documentation, please refer to the README.md in the top-level
# directory. For more detailed documentation, refer to the project wiki, hosted
# on Github: https://github.com/bhilburn/powerlevel9k/wiki
#
# There are a lot of easy ways you can customize your prompt segments and
# theming with simple variables defined in your `~/.zshrc`.
################################################################

## Turn on for Debugging
#PS4='%s%f%b%k%F{blue}%{λ%}%L %F{240}%N:%i%(?.. %F{red}%?) %1(_.%F{yellow}%-1_ .)%s%f%b%k '
#zstyle ':vcs_info:*+*:*' debug true
#set -o xtrace

# Try to set the installation path
if [[ -n "$POWERLEVEL9K_INSTALLATION_DIR" ]]; then
  p9k_directory=${POWERLEVEL9K_INSTALLATION_DIR:A}
else
  if [[ "${(%):-%N}" == '(eval)' ]]; then
    if [[ "$0" == '-antigen-load' ]] && [[ -r "${PWD}/powerlevel9k.zsh-theme" ]]; then
      # Antigen uses eval to load things so it can change the plugin (!!)
      # https://github.com/zsh-users/antigen/issues/581
      p9k_directory=$PWD
    else
      print -P "%F{red}You must set POWERLEVEL9K_INSTALLATION_DIR work from within an (eval).%f"
      return 1
    fi
  else
    # Get the path to file this code is executing in; then
    # get the absolute path and strip the filename.
    # See https://stackoverflow.com/a/28336473/108857
    p9k_directory=${${(%):-%x}:A:h}
  fi
fi

################################################################
# Source icon functions
################################################################

source "${p9k_directory}/functions/icons.zsh"

################################################################
# Source utility functions
################################################################

source "${p9k_directory}/functions/utilities.zsh"

################################################################
# Source color functions
################################################################

source "${p9k_directory}/functions/colors.zsh"

################################################################
# Source VCS_INFO hooks / helper functions
################################################################

source "${p9k_directory}/functions/vcs.zsh"

################################################################
# Color Scheme
################################################################

if [[ "$POWERLEVEL9K_COLOR_SCHEME" == "light" ]]; then
  DEFAULT_COLOR=white
  DEFAULT_COLOR_INVERTED=black
else
  DEFAULT_COLOR=black
  DEFAULT_COLOR_INVERTED=white
fi

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

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

# Begin a left prompt segment
# Takes four arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
# The latter three can be omitted,
set_default last_left_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "
left_prompt_segment() {
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

  local bg fg
  [[ -n "$3" ]] && bg="$(backgroundColor $3)" || bg="$(backgroundColor)"
  [[ -n "$4" ]] && fg="$(foregroundColor $4)" || fg="$(foregroundColor)"

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
    [[ -n "$4" ]] && complement="$fg" || complement="$(foregroundColor $DEFAULT_COLOR)"
    echo -n "${bg}${complement}"
    if [[ $joined == false ]]; then
      echo -n "$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
    fi
  else
    # First segment
    echo -n "${bg}$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
  fi

  local visual_identifier
  if [[ -n $6 ]]; then
    visual_identifier="$(print_icon $6)"
    if [[ -n "$visual_identifier" ]]; then
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable=POWERLEVEL9K_${(U)1#prompt_}_VISUAL_IDENTIFIER_COLOR
      set_default $visual_identifier_color_variable $4
      visual_identifier="%F{${(P)visual_identifier_color_variable}%}$visual_identifier%f"
      # Add an whitespace if we print more than just the visual identifier
      [[ -n "$5" ]] && visual_identifier="$visual_identifier "
    fi
  fi

  # Print the visual identifier
  echo -n "${visual_identifier}"
  # Print the content of the segment, if there is any
  [[ -n "$5" ]] && echo -n "${fg}${5}"
  echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"

  CURRENT_BG=$3
  last_left_element_index=$current_index
}

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

# Begin a right prompt segment
# Takes four arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default last_right_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  local current_index=$2

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

  local bg fg
  [[ -n "$3" ]] && bg="$(backgroundColor $3)" || bg="$(backgroundColor)"
  [[ -n "$4" ]] && fg="$(foregroundColor $4)" || fg="$(foregroundColor)"

  # If CURRENT_RIGHT_BG is "NONE", we are the first right segment.
  if [[ $joined == false ]] || [[ "$CURRENT_RIGHT_BG" == "NONE" ]]; then
    if isSameColor "$CURRENT_RIGHT_BG" "$3"; then
      # Middle segment with same color as previous segment
      # We take the current foreground color as color for our
      # subsegment (or the default color). This should have
      # enough contrast.
      local complement
      [[ -n "$4" ]] && complement="$fg" || complement="$(foregroundColor $DEFAULT_COLOR)"
      echo -n "$complement$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')%f"
    else
      # Use the new BG color for the foreground with separator
      echo -n "$(foregroundColor $3)$(print_icon 'RIGHT_SEGMENT_SEPARATOR')%f"
    fi
  fi

  local visual_identifier
  if [[ -n "$6" ]]; then
    visual_identifier="$(print_icon $6)"
    if [[ -n "$visual_identifier" ]]; then
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable=POWERLEVEL9K_${(U)1#prompt_}_VISUAL_IDENTIFIER_COLOR
      set_default $visual_identifier_color_variable $4
      visual_identifier="%F{${(P)visual_identifier_color_variable}%}$visual_identifier%f"
      # Add an whitespace if we print more than just the visual identifier
      [[ -n "$5" ]] && visual_identifier=" $visual_identifier"
    fi
  fi

  echo -n "${bg}${fg}"

  # Print whitespace only if segment is not joined or first right segment
  [[ $joined == false ]] || [[ "$CURRENT_RIGHT_BG" == "NONE" ]] && echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"

  # Print segment content if there is any
  [[ -n "$5" ]] && echo -n "${5}"
  # Print the visual identifier
  echo -n "${visual_identifier}${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"

  CURRENT_RIGHT_BG=$3
  last_right_element_index=$current_index
}

################################################################
# Prompt Segment Definitions
################################################################

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

################################################################
# The 'custom` prompt provides a way for users to invoke commands and display
# the output in a segment.
prompt_custom() {
  local command=POWERLEVEL9K_CUSTOM_$3:u
  local segment_content="$(eval ${(P)command})"

  if [[ -n $segment_content ]]; then
    "$1_prompt_segment" "${0}_${3:u}" "$2" $DEFAULT_COLOR_INVERTED $DEFAULT_COLOR "$segment_content"
  fi
}

################################################################
# Vi Mode: show editing mode (NORMAL|INSERT)
set_default POWERLEVEL9K_VI_INSERT_MODE_STRING "INSERT"
set_default POWERLEVEL9K_VI_COMMAND_MODE_STRING "NORMAL"
prompt_vi_mode() {
  case ${KEYMAP} in
    vicmd)
      "$1_prompt_segment" "$0_NORMAL" "$2" "$DEFAULT_COLOR" "default" "$POWERLEVEL9K_VI_COMMAND_MODE_STRING"
    ;;
    main|viins|*)
      if [[ -z $POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then return; fi
      "$1_prompt_segment" "$0_INSERT" "$2" "$DEFAULT_COLOR" "blue" "$POWERLEVEL9K_VI_INSERT_MODE_STRING"
    ;;
  esac
}

################################################################
# Prompt processing and drawing
################################################################
# Main prompt
build_left_prompt() {
  local index=1
  local element
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

powerlevel9k_preexec() {
  _P9K_TIMER_START=$EPOCHREALTIME
}

set_default POWERLEVEL9K_PROMPT_ADD_NEWLINE false
powerlevel9k_prepare_prompts() {
  RETVAL=$?
  RETVALS=( "$pipestatus[@]" )

  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))

  # Reset start time
  _P9K_TIMER_START=0x7FFFFFFF

  if [[ "$POWERLEVEL9K_PROMPT_ON_NEWLINE" == true ]]; then
    PROMPT='$(print_icon 'MULTILINE_FIRST_PROMPT_PREFIX')%f%b%k$(build_left_prompt)
$(print_icon 'MULTILINE_LAST_PROMPT_PREFIX')'
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
    PROMPT='%f%b%k$(build_left_prompt)'
    RPROMPT_PREFIX=''
    RPROMPT_SUFFIX=''
  fi

  if [[ "$POWERLEVEL9K_DISABLE_RPROMPT" != true ]]; then
    RPROMPT='$RPROMPT_PREFIX%f%b%k$(build_right_prompt)%{$reset_color%}$RPROMPT_SUFFIX'
  fi

NEWLINE='
'

  if [[ $POWERLEVEL9K_PROMPT_ADD_NEWLINE == true ]]; then
    NEWLINES=""
    repeat ${POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT:-1} { NEWLINES+=$NEWLINE }
    PROMPT="$NEWLINES$PROMPT"
  fi

  # Allow iTerm integration to work
  [[ $ITERM_SHELL_INTEGRATION_INSTALLED == "Yes" ]] && PROMPT="%{$(iterm2_prompt_mark)%}$PROMPT"
}

zle-keymap-select () {
	zle reset-prompt
	zle -R
}

set_default POWERLEVEL9K_IGNORE_TERM_COLORS false
set_default POWERLEVEL9K_IGNORE_TERM_LANG false

prompt_powerlevel9k_setup() {
  # The value below was set to better support 32-bit CPUs.
  # It's the maximum _signed_ integer value on 32-bit CPUs.
  # Please don't change it until 19 January of 2038. ;)

  # Disable false display of command execution time
  _P9K_TIMER_START=0x7FFFFFFF

  # The prompt function will set these prompt_* options after the setup function
  # returns. We need prompt_subst so we can safely run commands in the prompt
  # without them being double expanded and we need prompt_percent to expand the
  # common percent escape sequences.
  prompt_opts=(cr percent sp subst)

  # Borrowed from promptinit, sets the prompt options in case the theme was
  # not initialized via promptinit.
  setopt noprompt{bang,cr,percent,sp,subst} "prompt${^prompt_opts[@]}"

  # Display a warning if the terminal does not support 256 colors
  termColors

  # If the terminal `LANG` is set to `C`, this theme will not work at all.
  if [[ $POWERLEVEL9K_IGNORE_TERM_LANG == false ]]; then
      local term_lang
      term_lang=$(echo $LANG)
      if [[ $term_lang == 'C' ]]; then
          print -P "\t%F{red}WARNING!%f Your terminal's 'LANG' is set to 'C', which breaks this theme!"
          print -P "\t%F{red}WARNING!%f Please set your 'LANG' to a UTF-8 language, like 'en_US.UTF-8'"
          print -P "\t%F{red}WARNING!%f _before_ loading this theme in your \~\.zshrc. Putting"
          print -P "\t%F{red}WARNING!%f %F{blue}export LANG=\"en_US.UTF-8\"%f at the top of your \~\/.zshrc is sufficient."
      fi
  fi

  defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
  defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)

  # Display a warning if deprecated segments are in use.
  typeset -AH deprecated_segments
  # old => new
  deprecated_segments=(
    'longstatus'      'status'
  )
  print_deprecation_warning deprecated_segments

  # initialize colors
  autoload -U colors && colors

  # load only the segments that are being used!
  for segment in $p9k_directory/segments/**/*.p9k; do
    local segment_file=${segment##*/}
    local segment_name=${segment_file//.p9k/}
    if segment_in_use "$segment_name"; then
      source "${segment}"
    fi
  done

  # cleanup temporary variable
  unset p9k_directory

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

  zle -N zle-keymap-select
}

prompt_powerlevel9k_teardown() {
  add-zsh-hook -D precmd powerlevel9k_\*
  add-zsh-hook -D preexec powerlevel9k_\*
  PROMPT='%m%# '
  RPROMPT=
}

prompt_powerlevel9k_setup "$@"
