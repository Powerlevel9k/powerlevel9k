#!/usr/bin/env zsh
# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8
################################################################
# @title powerlevel9k Utility Functions
# @source [powerlevel9k](https://github.com/bhilburn/powerlevel9k)
##
# @info
#   This file contains some utility-functions for
#   the powerlevel9k ZSH theme.
##

################################################################
# @description
#   Source all autoload functions.
##
# @noargs
##
function __p9k_source_autoloads() {
  local autoload_path="$__P9K_DIRECTORY/functions/autoload"
  # test if we already autoloaded the functions
  if [[ ${fpath[(ie)$autoload_path]} -gt ${#fpath} ]]; then
    fpath=( ${autoload_path} "${fpath[@]}" )
    autoload -Uz __p9k_get_unique_path
    autoload -Uz __p9k_segment_should_be_joined
    autoload -Uz __p9k_segment_should_be_printed
    autoload -Uz __p9k_truncate_path
    autoload -Uz __p9k_update_var_name
    autoload -Uz __p9k_upsearch
  fi
}
__p9k_source_autoloads

###############################################################
# @description
#   Determine the OS and version (if applicable).
##
# @noargs
##
# @result
#   __P9K_OS string Name of OS
#   __P9K_OS_ID string Version of OS
##
function __p9k_detect_os() {
  typeset -g __P9K_OS __P9K_OS_ID
  case $(uname) in
    Darwin)
      __P9K_OS='OSX'
      __P9K_OS_ID="$(uname -r)"
      [[ "$(which stat)" != "/usr/bin/stat" ]] && __P9K_OSX_COREUTILS=true || __P9K_OSX_COREUTILS=false
    ;;
    CYGWIN_NT-* | MINGW32_NT-* | MINGW64_NT*) __P9K_OS='Windows' ;;
    FreeBSD | OpenBSD | DragonFly) __P9K_OS='BSD' ;;
    Linux)
      __P9K_OS='Linux'
      local os_release=$((</etc/os-release) 2>/dev/null)
      [[ ${(f)os_release} =~ "ID=([A-Za-z]+)" ]] && __P9K_OS_ID="${match[1]}"
      case $(uname -o 2>/dev/null) in
        Android) __P9K_OS='Android' ;;
      esac
    ;;
    SunOS) __P9K_OS='Solaris' ;;
    *) __P9K_OS='' ;;
  esac
  readonly __P9K_OS
  readonly __P9K_OS_ID
}
__p9k_detect_os

################################################################
# @description
#   Identify Terminal Emulator.
#
#   Find out which emulator is being used for terminal specific options
#   The testing order is important, since some override others.
##
# @noargs
##
# @result
#  __P9K_TERMINAL string Readonly global with the terminal ID
##
function __p9k_detect_terminal() {
  typeset -g __P9K_TERMINAL
  if [[ "$TMUX" =~ "tmux" ]]; then
    __P9K_TERMINAL="tmux"
  elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    __P9K_TERMINAL="iterm"
  elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    __P9K_TERMINAL="appleterm"
  else
    if [[ "${__P9K_OS}" == "OSX" ]]; then
      local termtest=${$(ps -o 'command=' -p $(ps -o 'ppid='$$))[1]:t}
      # test if we are in a sudo su -
      if [[ ${termtest} == "zsh" ]]; then
        termtest=${$(ps -o 'command=' -p $(ps -o 'ppid=' -p $(ps -o 'ppid='$$)))[1]:t}
      fi
    else # Linux
      # see: https://askubuntu.com/a/966934
      if [[ $TTY = "/dev/tty"* ]]; then
        __P9K_TERMINAL="linux-console"
        return
      fi
      local pid=$$ termtest=''
      while true; do
        proc_stat=(${(@f)$(</proc/${pid}/stat)})
        termtest=${proc_stat[2]//[()]/}
        case "${termtest}" in
          gnome-terminal|guake|konsole|rxvt|termite|urxvt|xterm|yakuake)
            __P9K_TERMINAL="${termtest}"
            return
          ;;
          python*)
            local cmdline=(${(@f)$(</proc/${pid}/cmdline)})
            if [[ "$cmdline" =~ "\\bguake.main\\b" ]]; then
              __P9K_TERMINAL="guake"
              return
            fi
          ;;
        esac
        if test "$pid" = "1" -o "$pid" = ""; then
          __P9K_TERMINAL="unknown"
          return
        fi
        pid=${proc_stat[4]}
      done
    fi
    case "${termtest##*/}" in
      gnome-terminal*)          __P9K_TERMINAL="gnometerm";;
      iTerm2)                   __P9K_TERMINAL="iterm";;
      urxvt)                    __P9K_TERMINAL="rxvt";;
      xterm | xterm-256color)   __P9K_TERMINAL="xterm";;
      *tty*)                    __P9K_TERMINAL="tty";;
      *)                        __P9K_TERMINAL=${termtest##*/};;
    esac
  fi
  readonly __P9K_TERMINAL
}
__p9k_detect_terminal

###############################################################
# @description
#   This function determines if POWERLEVEL9K_ variables have
#   been previously defined and changes them to P9K_ variables.
##
# @noargs
##
function __p9k_update_environment_vars() {
  local envVar varType varName origVar newVar newVal
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

###############################################################
# @description
#   This function determines if a variable has been previously
#   defined, even if empty.
##
# @args
#   $1 string The name of the variable that should be checked.
##
# @returns
#   0 if the variable has been defined (even when empty).
##
function p9k::defined() {
  [[ ! -z "${(tP)1:-}" ]]
}

###############################################################
# @description
#   This function determine if a variable has been previously defined,
#   and only sets the value to the specified default if it hasn't.
##
# @args
#   $1 string The name of the variable that should be checked.
#   $2 string The default value.
##
# @returns
#   Nothing.
##
# @note
#   Typeset cannot set the value for an array, so this will only work
#   for scalar values.
##
function p9k::set_default() {
  local varname="$1"
  local default_value="$2"

  p9k::defined "$varname" || typeset -g "$varname"="$default_value"
}

###############################################################
# @description
#   Converts large memory values into a human-readable unit (e.g., bytes --> GB)
##
# @args
#   $1 integer The number which should be prettified.
#   $2 string The base of the number (default Bytes).
##
# @returns
#   String with the size in human readable format.
##
# @note
#   The base can be any of the following: B, K, M, G, T, P, E, Z, Y.
##
function p9k::print_size_human_readable() {
  typeset -F 2 size
  size="${1}"+0.00001
  local extension
  extension=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')
  local index=1

  # if the base is not Bytes
  if [[ -n $2 ]]; then
    local idx
    for idx in "${extension[@]}"; do
      if [[ "$2" == "${idx}" ]]; then
        break
      fi
      index=$(( ${index} + 1 ))
    done
  fi

  while (( (${size} / 1024) > 0.1 )); do
    size=$(( ${size} / 1024 ))
    index=$(( ${index} + 1 ))
  done

  echo "${size}${extension[$index]}"
}

###############################################################
# @description
#   Gets the first value out of a list of items that is not empty.
#   The items are examined by a callback-function.
##
# @args
#   $1 array A list of items.
#   $2 string A callback function to examine if the item is worthy.
##
# @notes
#   The callback function has access to the inner variable $item.
##
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

###############################################################
# @description
#   Determine if the passed segment is used in either the LEFT or
#   RIGHT prompt arrays.
##
# @args
#   $1 string The segment to be tested.
##
function p9k::segment_in_use() {
  local key=$1
  [[ -n "${P9K_LEFT_PROMPT_ELEMENTS[(r)${key}]}" ||
     -n "${P9K_LEFT_PROMPT_ELEMENTS[(r)${key}_joined]}" ||
     -n "${P9K_RIGHT_PROMPT_ELEMENTS[(r)${key}]}" ||
     -n "${P9K_RIGHT_PROMPT_ELEMENTS[(r)${key}_joined]}" ]]
}

###############################################################
# @description
#   Print a deprecation warning if an old segment is in use.
# @args
#   $1 associative-array An associative array that contains the
#   deprecated segments as keys, and the new segment names as values.
##
function __p9k_print_deprecation_warning() {
  typeset -AH raw_deprecated_segments
  raw_deprecated_segments=(${(kvP@)1})

  for key in ${(@k)raw_deprecated_segments}; do
    if p9k::segment_in_use $key; then
      # segment is deprecated
      print -P "%F{yellow}Warning!%f The '$key' segment is deprecated. Use '%F{blue}${raw_deprecated_segments[$key]}%f' instead. For more informations, have a look at the CHANGELOG.md."
    fi
  done
}

###############################################################
# @description
#   Print a deprecation warning if an old variable is in use.
# @args
#   $1 associative-array An associative array that contains
#   the deprecated variables as keys, and the new variable
#   names as values.
##
function __p9k_print_deprecation_var_warning() {
  typeset -AH raw_deprecated_variables
  raw_deprecated_variables=(${(kvP@)1})

  for key in ${(@k)raw_deprecated_variables}; do
    if p9k::defined "${key}"; then
      # segment is deprecated
      if ! __p9k_update_var_name ${key} $raw_deprecated_variables[$key]; then
        print -P "%F{yellow}Warning!%f The '%F{cyan}$key%f' variable is deprecated. This could not be updated to '%F{red}${raw_deprecated_variables[$key]}%f' for you. For more information, have a look at the CHANGELOG.md."
      fi
    fi
  done
}

###############################################################
# @description
#   Takes a list of variable names and returns the value of the 
#   the first defined one, even if it's an empty string. Useful
#   for cases when users can define variables that should take 
#   priority even if they are empty.
# @args
#   $1 optional flag '-n' as first argument will make function to 
#   return variable name instead of it's value.
#   $* List of variable names.
# @returns
#   First defined variable value, or it's name if '-n' is passed.
##
function p9k::find_first_defined() {
  local returnName
  while [ $# -ne 0 ]; do
    if [[ "$1" == "-n" ]]; then
      returnName=true
    elif [[ ! -z "${(P)1+x}" ]]; then
      [[ -n $returnName ]] && echo "$1" || echo "${(P)1}"
      break
    fi
    shift
  done
}

###############################################################
# @description
#   Takes a list of variable names and returns the value of the 
#   the first non empty one. 
# @args
#   $1 optional flag '-n' as first argument will make function to 
#   return variable name instead of it's value.
#   $* List of variable names.
# @returns
#   First non empty variable value, or it's name if '-n' is passed.
##
function p9k::find_first_non_empty() {
  local returnName
  while [ $# -ne 0 ]; do
    if [[ "$1" == "-n" ]]; then
      returnName=true
    elif [[ -n "${(P)1}" ]]; then
      [[ -n $returnName ]] && echo "$1" || echo "${(P)1}"
      break
    fi
    shift
  done
}

# Parse IP address from ifconfig on OSX and from IP on Linux
# Parameters:
#  $1 - string The desired Interface
#  $2 - string A root prefix for testing purposes
function p9k::parseIp() {
  local desiredInterface="${1}"

  if [[ -z "${desiredInterface}" ]]; then
    desiredInterface="^[^ ]+"
  fi

  local ROOT_PREFIX="${2}"
  if [[ "$OS" == "OSX" ]]; then
    # Get a plain list of all interfaces
    local rawInterfaces="$(${ROOT_PREFIX}/sbin/ifconfig -l 2>/dev/null)"
    # Parse into array (split by whitespace)
    local -a interfaces
    interfaces=(${=rawInterfaces})
    # Parse only relevant interface names
    local pattern="${desiredInterface}[^ ]?"
    local -a relevantInterfaces
    for rawInterface in $interfaces; do
      [[ "$rawInterface" =~ $pattern ]] && relevantInterfaces+=( $MATCH )
    done
    local newline=$'\n'
    for interfaceName in $relevantInterfaces; do
      local interface="$(${ROOT_PREFIX}/sbin/ifconfig $interfaceName 2>/dev/null)"
      if [[ "${interface}" =~ "lo[0-9]*" ]]; then
        continue
      fi
      # Check if interface is UP.
      if [[ "${interface//${newline}/}" =~ "<([^>]*)>(.*)inet[ ]+([^ ]*)" ]]; then
        local ipFound="${match[3]}"
        local -a interfaceStates=(${(s:,:)match[1]})
        if [[ "${interfaceStates[(r)UP]}" == "UP" ]]; then
          echo "${ipFound}"
          return 0
        fi
      fi
    done
  else
    local -a interfaces
    interfaces=( "${(f)$(${ROOT_PREFIX}/sbin/ip -brief -4 a show 2>/dev/null)}" )
    local pattern="^${desiredInterface}[ ]+UP[ ]+([^/ ]+)"
    for interface in "${(@)interfaces}"; do
      if [[ "$interface" =~ $pattern ]]; then
        echo "${match[1]}"
        return 0
      fi
    done
  fi

  return 1
}
