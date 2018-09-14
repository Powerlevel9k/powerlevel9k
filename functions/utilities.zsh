# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# Utility functions
# This file holds some utility-functions for
# the powerlevel9k-ZSH-theme
# https://github.com/bhilburn/powerlevel9k
################################################################

###############################################################
# description
#   Determine the OS and version (if applicable).
case $(uname) in
  Darwin)
    __P9K_OS='OSX'
    __P9K_OS_ID="$(uname -r)"
    [[ "$(which stat)" != "/usr/bin/stat" ]] && __P9K_OSX_COREUTILS=true || __P9K_OSX_COREUTILS=false
  ;;
  CYGWIN_NT-* | MSYS_NT-*) __P9K_OS='Windows' ;;
  FreeBSD | OpenBSD | DragonFly) __P9K_OS='BSD' ;;
  Linux)
    __P9K_OS='Linux'
    __P9K_OS_ID="$(grep -E '^ID=([a-zA-Z]*)' /etc/os-release | cut -d '=' -f 2)"
    case $(uname -o 2>/dev/null) in
      Android) __P9K_OS='Android' ;;
    esac
  ;;
  SunOS) __P9K_OS='Solaris' ;;
  *) __P9K_OS='' ;;
esac

################################################################
# description
#   Identify Terminal Emulator.
##
#   Find out which emulator is being used for terminal specific options
#   The testing order is important, since some override others.
if [[ "$TMUX" =~ "tmux" ]]; then
  readonly __P9K_TERMINAL="tmux"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  readonly __P9K_TERMINAL="iterm"
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  readonly __P9K_TERMINAL="appleterm"
else
  if [[ "$OS" == "OSX" ]]; then
    local termtest=$(ps -o 'command=' -p $(ps -o 'ppid=' -p $$) | tail -1 | awk '{print $NF}')
    # test if we are in a sudo su -
    if [[ ${termtest} == "-" || ${termtest} == "root" ]]; then
      termtest=($(ps -o 'command=' -p $(ps -o 'ppid=' -p $(ps -o 'ppid='$$))))
      termtest=$(basename $termtest[1])
    fi
  else
    local termtest=$(ps -o 'cmd=' -p $(ps -o 'ppid=' -p $$) | tail -1 | awk '{print $NF}')
    # test if we are in a sudo su -
    if [[ ${termtest} == "-" || ${termtest} == "root" ]]; then
      termtest=($(ps -o 'cmd=' -p $(ps -o 'ppid=' $(ps -o 'ppid='$$))))
      if [[ $termtest[1] == "zsh" ]]; then  # gnome terminal works differently than the rest... sigh
        termtest=$termtest[-1]
      elif [[ $termtest[1] =~ "python" ]]; then   # as does guake
        termtest=$termtest[3]
      else
        termtest=$termtest[1]
      fi
    fi
  fi
  case "${termtest##*/}" in
    gnome-terminal-server)    readonly __P9K_TERMINAL="gnometerm";;
    guake.main)               readonly __P9K_TERMINAL="guake";;
    iTerm2)                   readonly __P9K_TERMINAL="iterm";;
    konsole)                  readonly __P9K_TERMINAL="konsole";;
    termite)                  readonly __P9K_TERMINAL="termite";;
    urxvt)                    readonly __P9K_TERMINAL="rxvt";;
    yakuake)                  readonly __P9K_TERMINAL="yakuake";;
    xterm | xterm-256color)   readonly __P9K_TERMINAL="xterm";;
    *tty*)                    readonly __P9K_TERMINAL="tty";;
    *)                        readonly __P9K_TERMINAL=${termtest##*/};;
  esac

  unset termtest
  unset uname
fi

###############################################################
# @description
#   This function determines if POWERLEVEL9K_ variables have
#   been previously defined and changes them to P9K_ variables.
##
# @noargs
##
__p9k_update_environment_vars() {
  local envVar varType varName origVar newVar newVal var
  local oldVarsFound=false
  for envVar in $(declare); do
    if [[ ${envVar} =~ "POWERLEVEL9K_" ]]; then
      oldVarsFound=true
      varType=( "$(declare -p ${envVar})" )
      varName=${${envVar##POWERLEVEL9K_}%=*}
      origVar="POWERLEVEL9K_${varName}"
      newVar="P9K_${varName}"
      if [[ "${varType[1]:9:1}" == "a" || "${varType[1]:12:1}" == "a" ]]; then # array variable
        case ${(U)varName} in
          BATTERY_STAGES|BATTERY_LEVEL_BACKGROUND|LEFT_PROMPT_ELEMENTS|RIGHT_PROMPT_ELEMENTS)
            [[ "${varType[2]}" == "" ]] && var=${varType[1]} || var=${varType[2]} # older ZSH installs have 2 lines for declare
            newVal="${${${var##*\(}%\)*}//  / }" # remove brackets and extra spaces
            newVal="${newVal%"${newVal##*[! $'\t']}"}" # severe trick - remove trailing whitespace
            newVal="${newVal#"${newVal%%[! $'\t']*}"}" # severe trick - remove leading whitespace
          ;;
          BATTERY_STAGES)
            newVal=${${newVal}//\'/}
          ;;
        esac
        typeset -g -a $newVar
        : ${(PA)newVar::=${(s: :)newVal}} # array assignment with values split on space
      else
        newVal=${(P)origVar}
        : ${(P)newVar::=$newVal}
      fi
      unset $origVar
    fi
  done
  [[ $P9K_IGNORE_VAR_WARNING == true ]] && oldVarsFound=false # disable warning if user sets P9K_IGNORE_VAR_WARNING to true.
  [[ ${oldVarsFound} == true ]] && print -P "%F{yellow}Information!%f As of this update, the %F{cyan}POWERLEVEL9K_*%f variables have been replaced by %F{cyan}P9K_*%f.
  Variables have been converted automatically, but there may still be some errors. For more information, have a look at the CHANGELOG.md.
  To disable this warning, please modify your configuration file to use the new style variables, or add %F{green}P9K_IGNORE_VAR_WARNING=true%f to your config."
}

__p9k_update_environment_vars

# Exits with 0 if a variable has been previously defined (even if empty)
# Takes the name of a variable that should be checked.
function p9k::defined() {
  [[ ! -z "${(tP)1}" ]]
}

# Given the name of a variable and a default value, sets the variable
# value to the default only if it has not been defined.
#
# Typeset cannot set the value for an array, so this will only work
# for scalar values.
function p9k::set_default() {
  local varname="$1"
  local default_value="$2"

  p9k::defined "$varname" || typeset -g "$varname"="$default_value"
}

# Converts large memory values into a human-readable unit (e.g., bytes --> GB)
# Takes two arguments:
#   * $size - The number which should be prettified
#   * $base - The base of the number (default Bytes)
p9k::print_size_human_readable() {
  typeset -F 2 size
  size="$1"+0.00001
  local extension
  extension=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')
  local index=1

  # if the base is not Bytes
  if [[ -n $2 ]]; then
    local idx
    for idx in "${extension[@]}"; do
      if [[ "$2" == "$idx" ]]; then
        break
      fi
      index=$(( index + 1 ))
    done
  fi

  while (( (size / 1024) > 0.1 )); do
    size=$(( size / 1024 ))
    index=$(( index + 1 ))
  done

  echo "$size${extension[$index]}"
}

# Gets the first value out of a list of items that is not empty.
# The items are examined by a callback-function.
# Takes two arguments:
#   * $list - A list of items
#   * $callback - A callback function to examine if the item is
#                 worthy. The callback function has access to
#                 the inner variable $item.
function p9k::get_relevant_item() {
  local -a list
  local callback
  # Explicitly split the elements by whitespace.
  list=(${=1})
  callback=$2

  for item in $list; do
    # The first non-empty item wins
    try=$(eval "$callback")
    if [[ -n "$try" ]]; then
      echo "$try"
      break;
    fi
  done
}

# Determine the correct sed parameter.
#
# `sed` is unfortunately not consistent across OSes when it comes to flags.
SED_EXTENDED_REGEX_PARAMETER="-r"
if [[ "$__P9K_OS" == 'OSX' ]]; then
  local IS_BSD_SED="$(sed --version &>> /dev/null || echo "BSD sed")"
  if [[ -n "$IS_BSD_SED" ]]; then
    SED_EXTENDED_REGEX_PARAMETER="-E"
  fi
fi

# Determine if the passed segment is used in the prompt
#
# Pass the name of the segment to this function to test for its presence in
# either the LEFT or RIGHT prompt arrays.
#    * $1: The segment to be tested.
p9k::segment_in_use() {
  local key=$1
  if [[ -n "${P9K_LEFT_PROMPT_ELEMENTS[(r)$key]}" ]] || [[ -n "${P9K_RIGHT_PROMPT_ELEMENTS[(r)$key]}" ]]; then
    return 0
  else
    return 1
  fi
}

# Print a deprecation warning if an old segment is in use.
# Takes the name of an associative array that contains the
# deprecated segments as keys, the values contain the new
# segment names.
__p9k_print_deprecation_warning() {
  typeset -AH raw_deprecated_segments
  raw_deprecated_segments=(${(kvP@)1})

  for key in ${(@k)raw_deprecated_segments}; do
    if p9k::segment_in_use $key; then
      # segment is deprecated
      print -P "%F{yellow}Warning!%f The '$key' segment is deprecated. Use '%F{blue}${raw_deprecated_segments[$key]}%f' instead. For more informations, have a look at the CHANGELOG.md."
    fi
  done
}

# A helper function to determine if a segment should be
# joined or promoted to a full one.
# Takes three arguments:
#   * $1: The array index of the current segment
#   * $2: The array index of the last printed segment
#   * $3: The array of segments of the left or right prompt
function __p9k_segment_should_be_joined() {
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

################################################################
# Given a directory path, truncate it according to the settings.
# Parameters:
#   * $1 Path: string - the directory path to be truncated
#   * $2 Length: integer - length to truncate to
#   * $3 Delimiter: string - the delimiter to use
#   * $4 From: string - "right" | "middle". If omited, assumes right.
function __p9k_truncate_path() {
  # if the current path is not 1 character long (e.g. "/" or "~")
  if (( ${#1} > 1 )); then
    # convert $2 from string to integer
    2=$(( $2 ))
    # set $3 to "" if not defined
    [[ -z $3 ]] && 3="" || 3=$(echo -n $3)
    # set $4 to "right" if not defined
    [[ -z $4 ]] && 4="right"
    # create a variable for the truncated path.
    local trunc_path
    # if the path is in the home folder, add "~/" to the start otherwise "/"
    [[ $1 == "~"* ]] && trunc_path='~/' || trunc_path='/'
    # split the path into an array using "/" as the delimiter
    local paths=$1
    paths=(${(s:/:)${paths//"~\/"/}})
    # declare locals for the directory being tested and its length
    local test_dir test_dir_length
    # do the needed truncation
    case $4 in
      right)
        # include the delimiter length in the threshhold
        local threshhold=$(( $2 + ${#3} ))
        # loop through the paths
        for (( i=1; i<${#paths}; i++ )); do
          # get the current directory value
          test_dir=$paths[$i]
          test_dir_length=${#test_dir}
          # only truncate if the resulting truncation will be shorter than
          # the truncation + delimiter length and at least 3 characters
          if (( $test_dir_length > $threshhold )) && (( $test_dir_length > 3 )); then
            # use the first $2 characters and the delimiter
            trunc_path+="${test_dir:0:$2}$3/"
          else
            # use the full path
            trunc_path+="${test_dir}/"
          fi
        done
      ;;
      middle)
        # we need double the length for start and end truncation + delimiter length
        local threshhold=$(( $2 * 2 ))
        # create a variable for the start of the end truncation
        local last_pos
        # loop through the paths
        for (( i=1; i<${#paths}; i++ )); do
          # get the current directory value
          test_dir=$paths[$i]
          test_dir_length=${#test_dir}
          # only truncate if the resulting truncation will be shorter than
          # the truncation + delimiter length
          if (( $test_dir_length > $threshhold )); then
            # use the first $2 characters, the delimiter and the last $2 characters
            last_pos=$(( $test_dir_length - $2 ))
            trunc_path+="${test_dir:0:$2}$3${test_dir:$last_pos:$test_dir_length}/"
          else
            # use the full path
            trunc_path+="${test_dir}/"
          fi
        done
      ;;
    esac
    # return the truncated path + the current directory
    echo $trunc_path${1:t}
  else # current path is 1 character long (e.g. "/" or "~")
    echo $1
  fi
}

# Search recursively in parent folders for given file.
function __p9k_upsearch() {
  if [[ "$PWD" == "$HOME" || "$PWD" == "/" ]]; then
    echo "$PWD"
  elif test -e "$1"; then
    pushd .. > /dev/null
    __p9k_upsearch "$1"
    popd > /dev/null
    echo "$PWD"
  else
    pushd .. > /dev/null
    __p9k_upsearch "$1"
    popd > /dev/null
  fi
}
